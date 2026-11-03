"""Build the PowerPoint reference document for the slide decks

Quarto (pandoc) fills slides from layouts with standard names and placeholder
types ("Title Slide", "Title and Content", "Two Content", ...), and uses only
the first slide master. The Epicentre template's layouts have French names and
text placeholders only, and are spread over several masters, so this script
takes a deck in that template, deletes its slides, keeps only its content
master (blue title, dot pattern and gold slide-number bar), and rebuilds that
master's layouts under pandoc's names with the template's title and text
styles. The cover ("première 1", blue background and logos) is copied into
the content master as "Title Slide".

Usage, from the repository root:
    python3 qmd/templates/build_reference_pptx.py <template.pptx> qmd/templates/epicentre_reference.pptx
"""

import copy
import sys

from pptx import Presentation
from pptx.oxml import parse_xml
from pptx.opc.constants import RELATIONSHIP_TYPE as RT
from pptx.opc.packuri import PackURI

R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
P = "http://schemas.openxmlformats.org/presentationml/2006/main"

NS = (
    'xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" '
    'xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"'
)

# Geometry in EMU (slide 12,192,000 x 6,858,000), from the template's
# "texte court" layout
LEFT, WIDTH = 551281, 11089438
TITLE_Y, TITLE_H = 413400, 590358
BODY_Y, BODY_H = 1417159, 4696354
GAP = 245000
HALF = (WIDTH - GAP) // 2

# The template's title style: Ubuntu Light, accent blue
TITLE_STYLE = """<a:lstStyle><a:lvl1pPr marL="0" indent="0"><a:buNone/>
<a:defRPr sz="3200" b="0"><a:solidFill><a:schemeClr val="accent1"/></a:solidFill>
<a:latin typeface="Ubuntu Light"/></a:defRPr></a:lvl1pPr></a:lstStyle>"""


def body_style(sizes):
    """The template's text style (accent bullets) at the given point sizes"""
    lvl = []
    for i, sz in enumerate(sizes, start=1):
        colour = "accent1" if i == 1 else "accent2"
        lvl.append(
            f'<a:lvl{i}pPr><a:buClr><a:schemeClr val="{colour}"/></a:buClr>'
            f'<a:defRPr sz="{sz * 100}"><a:latin typeface="+mn-lt"/></a:defRPr></a:lvl{i}pPr>'
        )
    return "<a:lstStyle>" + "".join(lvl) + "</a:lstStyle>"


def placeholder(sp_id, name, ph, x, y, cx, cy, style):
    return parse_xml(
        f"""<p:sp {NS}><p:nvSpPr><p:cNvPr id="{sp_id}" name="{name}"/>
<p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr><p:nvPr>{ph}</p:nvPr></p:nvSpPr>
<p:spPr><a:xfrm><a:off x="{x}" y="{y}"/><a:ext cx="{cx}" cy="{cy}"/></a:xfrm>
<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></p:spPr>
<p:txBody><a:bodyPr><a:normAutofit/></a:bodyPr>{style}<a:p><a:endParaRPr lang="en-GB"/></a:p></p:txBody></p:sp>"""
    )


def title(sp_id=2):
    return placeholder(sp_id, "Title", '<p:ph type="title"/>', LEFT, TITLE_Y, WIDTH, TITLE_H, TITLE_STYLE)


def rebuild(layout, name, shapes):
    """Replace a layout's shapes with `shapes` and rename it"""
    tree = layout.shapes._spTree
    for sp in list(tree)[2:]:  # keep nvGrpSpPr and grpSpPr
        tree.remove(sp)
    for sp in shapes:
        tree.append(sp)
    layout._element.cSld.set("name", name)


def main(src, dest):
    prs = Presentation(src)

    # Drop the slides: only masters, layouts and theme are kept
    sld_ids = prs.slides._sldIdLst
    for sld_id in list(sld_ids):
        prs.part.drop_rel(sld_id.rId)
        sld_ids.remove(sld_id)

    masters = prs.slide_masters
    layouts = {(i, l.name): l for i, m in enumerate(masters) for l in m.slide_layouts}
    content = 2  # the master of the content slides

    full = body_style([18, 16, 14])
    half = body_style([16, 14, 12])
    caption = body_style([14, 12, 12])

    rebuild(layouts[(content, "Title and Content")], "Title and Content", [
        title(),
        placeholder(3, "Content", '<p:ph idx="1"/>', LEFT, BODY_Y, WIDTH, BODY_H, full),
    ])
    rebuild(layouts[(content, "visuel texte")], "Two Content", [
        title(),
        placeholder(3, "Left", '<p:ph sz="half" idx="1"/>', LEFT, BODY_Y, HALF, BODY_H, half),
        placeholder(4, "Right", '<p:ph sz="half" idx="2"/>', LEFT + HALF + GAP, BODY_Y, HALF, BODY_H, half),
    ])
    # Text (e.g. key points) under a figure or table
    fig_h = 3150000
    rebuild(layouts[(content, "visuel")], "Content with Caption", [
        title(),
        placeholder(3, "Content", '<p:ph idx="1"/>', LEFT, BODY_Y, WIDTH, fig_h, full),
        placeholder(4, "Caption", '<p:ph type="body" sz="half" idx="2"/>', LEFT, BODY_Y + fig_h + 60000,
                    WIDTH, BODY_H - fig_h - 60000, caption),
    ])
    head_h = 450000
    rebuild(layouts[(content, "sommaire")], "Comparison", [
        title(),
        placeholder(3, "Left heading", '<p:ph type="body" idx="1"/>', LEFT, BODY_Y, HALF, head_h, half),
        placeholder(4, "Left content", '<p:ph sz="half" idx="2"/>', LEFT, BODY_Y + head_h, HALF, BODY_H - head_h, half),
        placeholder(5, "Right heading", '<p:ph type="body" sz="quarter" idx="3"/>', LEFT + HALF + GAP, BODY_Y,
                    HALF, head_h, half),
        placeholder(6, "Right content", '<p:ph sz="quarter" idx="4"/>', LEFT + HALF + GAP, BODY_Y + head_h,
                    HALF, BODY_H - head_h, half),
    ])
    # Cover: the first master's "première 1" copied into the content master in
    # place of "texte court", on the cover's blue background without the
    # content master's decorations, its text placeholders typed as title,
    # subtitle and date
    src_cover = layouts[(0, "première 1")]
    cover = layouts[(content, "texte court")]
    shapes = []
    for sp in list(src_cover.shapes._spTree)[2:]:
        sp = copy.deepcopy(sp)
        # Images: relate the copied shapes to the same image parts
        for el in sp.iter():
            for attr, rid in list(el.attrib.items()):
                if attr.startswith(f"{{{R}}}"):
                    part = src_cover.part.related_part(rid)
                    el.set(attr, cover.part.relate_to(part, RT.IMAGE))
        shapes.append(sp)
    rebuild(cover, "Title Slide", shapes)
    types = {"10": '<p:ph type="ctrTitle"/>', "11": '<p:ph type="subTitle" idx="1"/>', "12": '<p:ph type="dt" idx="10"/>'}
    for sp in cover.placeholders:
        idx = str(sp.placeholder_format.idx)
        if idx in types:
            nv = sp._element.nvSpPr.nvPr
            nv.remove(nv.find(f"{{{P}}}ph"))
            nv.insert(0, parse_xml(types[idx].replace("<p:ph", f"<p:ph {NS}")))
    cover._element.set("showMasterSp", "0")
    cover._element.cSld.insert(0, parse_xml(
        f'<p:bg {NS}><p:bgPr><a:solidFill><a:schemeClr val="accent1"/></a:solidFill><a:effectLst/></p:bgPr></p:bg>'
    ))

    # Keep only the content master, as pandoc uses the first master only, and
    # give it, its theme and its layouts the first part names, which pandoc
    # reads
    master_ids = prs.part._element.sldMasterIdLst
    for i, sld_master_id in enumerate(list(master_ids)):
        if i != content:
            prs.part.drop_rel(sld_master_id.rId)
            master_ids.remove(sld_master_id)
    master = prs.slide_masters[0]
    wanted = {master.part: "/ppt/slideMasters/slideMaster1.xml", master.part.part_related_by(RT.THEME): "/ppt/theme/theme1.xml"}
    # pandoc's file number for each layout; layouts it does not find are
    # copied from its default reference under these numbers, overwriting
    # whatever has the same name
    pandoc_number = {"Title Slide": 1, "Title and Content": 2, "Two Content": 4, "Comparison": 5, "Content with Caption": 8}
    for layout in master.slide_layouts:
        wanted[layout.part] = f"/ppt/slideLayouts/slideLayout{pandoc_number[layout.name]}.xml"
    # Other parts (e.g. the notes master's theme) that hold these names move
    # to unused ones
    parts = list(prs.part.package.iter_parts())
    taken = {str(p.partname) for p in parts}
    for p in parts:
        if p not in wanted and str(p.partname) in wanted.values():
            stem, ext = str(p.partname).rsplit(".", 1)
            n = 100
            while f"{stem}_{n}.{ext}" in taken:
                n += 1
            p.partname = PackURI(f"{stem}_{n}.{ext}")
            taken.add(str(p.partname))
    for p, name in wanted.items():
        p.partname = PackURI(name)

    # Parts that pandoc does not copy into the deck but whose relationships
    # from presentation.xml it keeps: left in, PowerPoint asks to repair every
    # deck
    for rid, rel in list(prs.part.rels.items()):
        if rel.reltype.rsplit("/", 1)[-1] in ("customXml", "revisionInfo", "authors", "commentAuthors"):
            prs.part.drop_rel(rid)
    # The presentation's theme is the kept master's
    for rid, rel in list(prs.part.rels.items()):
        if rel.reltype == RT.THEME:
            prs.part.drop_rel(rid)
    prs.part.relate_to(master.part.part_related_by(RT.THEME), RT.THEME)

    prs.save(dest)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
