// Navigation for the single-page edition of the book (`_out/html-single`).
//
// Verso's table of contents at the top of the single page has empty links, so it is rebuilt here
// from the chapter and section headings, which carry the anchors. A small button in the corner
// returns to the contents from anywhere in the book.

(function () {
    const root = document.querySelector("main .content-wrapper > section");
    if (!root) return;

    /** The heading's title, without its permalink widget, split into its number and its name. */
    function headingTitle(heading) {
        const clone = heading.cloneNode(true);
        clone.querySelectorAll(".permalink-widget").forEach((w) => w.remove());
        const text = clone.textContent.trim().replace(/\s+/g, " ");
        const match = text.match(/^(\d+(?:\.\d+)*\.)\s+(.*)$/);
        return match ? { number: match[1], name: match[2] } : { number: "", name: text };
    }

    function entry(heading) {
        const li = document.createElement("li");
        const a = document.createElement("a");
        a.href = "#" + heading.id;
        const { number, name } = headingTitle(heading);
        if (number) {
            const num = document.createElement("span");
            num.className = "section-number";
            num.textContent = number;
            a.append(num, " ");
        }
        a.append(name);
        li.append(a);
        return li;
    }

    const chapters = document.createElement("ol");
    chapters.className = "single-toc";
    for (const chapter of root.querySelectorAll(":scope > section")) {
        const heading = chapter.querySelector(":scope > h2[id]");
        if (!heading) continue;
        const li = entry(heading);
        const sections = document.createElement("ol");
        for (const section of chapter.querySelectorAll(":scope > section > h3[id]")) {
            sections.append(entry(section));
        }
        if (sections.childElementCount > 0) li.append(sections);
        chapters.append(li);
    }

    const verso = root.querySelector(":scope > section > ol.section-toc");
    if (!verso) return;
    const contents = verso.parentElement;
    contents.id = "contents";
    verso.replaceWith(chapters);

    const back = document.createElement("a");
    back.href = "#contents";
    back.className = "single-to-contents";
    back.title = "Contents";
    back.setAttribute("aria-label", "Back to the contents");
    back.textContent = "↑";
    document.body.append(back);
})();
