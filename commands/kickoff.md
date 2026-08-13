> **Legacy V1 command:** This file preserves the former fixed-phase workflow for existing installs. New V2 setups use `skills/kickoff/SKILL.md`; see `docs/v2-migration.md`.

Ich starte ein **neues Projekt von Grund auf**. Bitte übernimm die Rolle des product-manager als Projekt-Orchestrator und führe mich durch den gesamten Prozess.

> Wenn du ein bestehendes Projekt weiterentwickeln möchtest, nutze stattdessen `/feature`.

## Projektidee

$ARGUMENTS

## Scope Override (optional)

Du kannst den Scope manuell setzen, um die Auto-Detection zu überschreiben:
`/kickoff --scope nano|micro|standard|large "Deine Projektidee"`

| Flag               | Wann nutzen                                                       |
| ------------------ | ----------------------------------------------------------------- |
| `--scope nano`     | Winzige Einzel-Änderung — direkt implementieren                   |
| `--scope micro`    | Kleine Änderung — minimale Requirements, kein Architecture Review |
| `--scope standard` | Normales Projekt — voller Workflow                                |
| `--scope large`    | Komplexes Produkt — voller Workflow + extended QA                 |

## Resume (optional)

Steig direkt bei einer bestimmten Phase ein, ohne von vorne zu beginnen:
`/kickoff --from requirements|design|architecture|implementation|qa "Deine Projektidee"`

| Flag                    | Startet bei                         |
| ----------------------- | ----------------------------------- |
| `--from requirements`   | Phase 2: Requirements & UX Research |
| `--from design`         | Phase 3: UI Mockups                 |
| `--from architecture`   | Phase 4: Tech-Entscheidungen        |
| `--from implementation` | Phase 5: Developer-Phase            |
| `--from qa`             | Phase 6: QA-Review                  |

**Kombinierbar:** `/kickoff --scope standard --from design "My app idea"`

## Dein Auftrag

Bevor du loslegst, stell mir kurze Rückfragen zu:
- **Zielgruppe**: Wer sind die Nutzer?
- **Scope**: MVP oder Full Product?
- **Plattform**: Web / Mobile / Desktop / Responsive Web App?
- **Timeline**: Gibt es eine Zeitvorstellung?
- **Tech-Präferenzen**: Next.js + Vercel als Default, oder etwas anderes?
- **Was existiert bereits**: Notizen, Mockups, Referenzen?

Sobald ich geantwortet habe, starte den Workflow:

### Phase 1: Setup
- Erstelle ein GitHub Repo mit sinnvoller Struktur
- Richte ein GitHub Projects Board ein (Backlog → Ready → In Progress → Review → Done)
- Definiere Milestones: Discovery → Design → Architecture → Implementation → QA → Launch
- Erstelle `docs/lessons.md` für phasenübergreifende Lernmuster (wird nach Phasenproblemen befüllt)
- Erstelle `docs/sot/` Verzeichnis (kopiere `docs/sot/TEMPLATE.md` als Vorlage für Source-of-Truth-Einträge)
- Erstelle STATUS.md mit Phase-Gate-Tabelle (aktuelle Phase, Scope, Fortschritt, SoT-Register)

#### DoD Phase 1:
- [ ] GitHub Repo mit Struktur erstellt
- [ ] Projects Board eingerichtet (5 Spalten)
- [ ] Milestones definiert
- [ ] `docs/lessons.md` angelegt
- [ ] `docs/sot/` Verzeichnis mit TEMPLATE.md angelegt
- [ ] STATUS.md mit Phase-Gate-Tabelle erstellt
- [ ] Human-Approval erhalten

### Phase 2: Requirements (product-manager + ux-researcher)
- Erarbeite im Dialog mit mir die Kernfeatures
- Schreibe für jedes Feature ein GitHub Issue mit User Story, Akzeptanzkriterien und Priorität (Must/Should/Could)
- Frag aktiv nach, wenn Infos fehlen
- **Dokumentiere harte Business Rules als SoT-Einträge (BR-xxx) in `docs/sot/`** (z.B. Limits, Constraints, Geschäftsregeln)
- **Dokumentiere Kern-User-Journeys als SoT-Einträge (UJ-xxx) in `docs/sot/`**
- **Erstelle am Ende `docs/handoffs/01_requirements.md`. Inhalt: Zielgruppe, Scope, Liste der Kern-Features (mit Issue-Links), Erfolgsmetriken und Referenzen auf SoT-IDs. Halte das Dokument kompakt — Details gehören in die SoT-Einträge.**

#### DoD Phase 2:
- [ ] Alle Features als GitHub Issues mit Akzeptanzkriterien
- [ ] Business Rules als SoT-Einträge (BR-xxx) dokumentiert
- [ ] Kern-User-Journeys als SoT-Einträge (UJ-xxx) dokumentiert
- [ ] `docs/handoffs/01_requirements.md` erstellt (kompakt, Details in SoT ausgelagert)
- [ ] Erfolgsmetriken definiert
- [ ] STATUS.md aktualisiert
- [ ] Human-Approval erhalten

### Phase 3: Design (product-designer)
- **Lies zuerst `docs/handoffs/01_requirements.md` und relevante SoT-Einträge (UJ-xxx), um den Kontext zu verstehen.**
- Erstelle eine Screen-Inventur basierend auf den Issues
- Generiere UI-Mockups mit Nano Banana Pro
- Lade die Mockups als Bildanhänge direkt in die jeweiligen GitHub Issues hoch
- Feedback und Design-Freigabe werden als Issue-Kommentare dokumentiert
- Hol mein Feedback ein bevor du weitermachst
- **Erstelle am Ende `docs/handoffs/02_design.md`. Inhalt: Liste aller Screens/Komponenten, Design-Entscheidungen (Farben, Stil) und Links zu den Issues mit den Mockups.**

#### DoD Phase 3:
- [ ] Screen-Inventur basierend auf Issues erstellt
- [ ] Mockups generiert und in Issues hochgeladen
- [ ] Design-Feedback eingeholt und eingearbeitet
- [ ] `docs/handoffs/02_design.md` erstellt
- [ ] STATUS.md aktualisiert
- [ ] Human-Approval erhalten

### Phase 4: Architektur (tech-lead)
- **Lies zuerst `docs/handoffs/01_requirements.md`, `docs/handoffs/02_design.md` und alle relevanten SoT-Einträge.**
- Schlage einen Tech Stack vor basierend auf Requirements und Scope
- **Dokumentiere Architektur-Entscheidungen als SoT-Einträge (ADR-xxx) in `docs/sot/`**
- **Dokumentiere API Contracts als SoT-Einträge (API-xxx) in `docs/sot/`**
- Kläre offene technische Fragen mit mir
- **Erstelle am Ende `docs/handoffs/03_architecture.md`. Inhalt: Gewählter Stack, Datenmodell (Grobkonzept), Referenzen auf ADR-xxx/API-xxx SoT-Einträge und externe Abhängigkeiten.**

#### DoD Phase 4:
- [ ] Tech Stack vorgeschlagen und abgestimmt
- [ ] Architektur-Entscheidungen als SoT-Einträge (ADR-xxx) erstellt
- [ ] API Contracts als SoT-Einträge (API-xxx) dokumentiert
- [ ] `docs/handoffs/03_architecture.md` erstellt
- [ ] STATUS.md aktualisiert
- [ ] Human-Approval erhalten

### Phase 5: Implementierung (developer)
- **Lies zuerst ALLE Dokumente in `docs/handoffs/` und `docs/sot/`, um das Gesamtbild zu verstehen, bevor du Code schreibst.**
- Arbeite die Tickets mit Design ab, eins nach dem anderen
- Issue auf "In Progress" im GitHub Projects Board setzen, bevor die Arbeit beginnt
- Feature-Branch pro Issue: `feat/<issue-id>-<kurzbeschreibung>`
- PR erstellen mit `Closes #<issue-id>` in der Beschreibung und Screenshots für UI-Änderungen
- Issue auf "Review" setzen, wenn der PR geöffnet wird
- Nutze die v0-generierten Komponenten aus Phase 3
- Referenziere relevante SoT-IDs in Code-Kommentaren wo es das Verständnis fördert (z.B. `// BR-003: Max 3 Projekte pro Free-User`)

#### DoD Phase 5:
- [ ] Alle Tickets mit Design abgearbeitet
- [ ] Feature-Branches + PRs erstellt mit `Closes #<issue-id>`
- [ ] Code folgt bestehenden Patterns und Konventionen
- [ ] SoT-Constraints (BR-xxx) im Code berücksichtigt
- [ ] STATUS.md aktualisiert

### Phase 6: QA (qa-lead)
- **Lies die relevanten SoT-Einträge (insbesondere BR-xxx Constraints) um gegen die richtigen Kriterien zu prüfen.**
- Reviewe den PR gegen die Akzeptanzkriterien im verlinkten Issue
- Feedback als PR-Kommentare, bei Problemen "Changes requested"
- PR approven wenn alle Kriterien erfüllt sind
- Nach dem Merge: Issue wird automatisch geschlossen und auf "Done" gesetzt
- Prüfe Edge Cases, Responsive, Accessibility
- Erstelle eine Release-Checkliste

#### DoD Phase 6:
- [ ] PRs gegen Akzeptanzkriterien und SoT-Constraints geprüft
- [ ] Edge Cases, Responsive, Accessibility getestet
- [ ] Release-Checkliste erstellt
- [ ] STATUS.md aktualisiert
- [ ] Human-Approval erhalten

### Phase 7: Deployment (tech-lead)
- Konfiguriere Vercel (oder alternatives Target)
- Deploye nach meinem finalen OK

#### DoD Phase 7:
- [ ] Deployment-Konfiguration geprüft
- [ ] Finales OK eingeholt
- [ ] Erfolgreiches Deployment bestätigt
- [ ] STATUS.md auf "done" gesetzt

---

Regeln:
- Frag mich an jedem Phasenübergang nach Feedback
- Halte den Status im Repo aktuell (STATUS.md)
- Wenn etwas unklar ist, frag nach — rate nicht
- Zeig mir Zwischenergebnisse, damit ich früh korrigieren kann
- Lies `docs/lessons.md` zu Beginn jeder Phase auf Muster, die relevant sein könnten
- Wenn eine Phase Korrekturen brauchte oder etwas schiefgelaufen ist: halte die Lektion in `docs/lessons.md` fest — welches Muster war es und welche Regel hätte den Fehler verhindert?
- Wenn etwas schiefläuft: STOPP und neu planen — nicht weiterpushen

Starte jetzt mit deinen Rückfragen.
