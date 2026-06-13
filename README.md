# GCode 3D Generator

> Application web **single-file** (HTML + CSS + JS) pour générer et visualiser du G-code d'usinage CNC 3 axes simultanés (X, Y, Z) à partir d'un fichier STL.  
> **Aucun serveur requis** — tout tourne dans le navigateur, hors-ligne possible.

---

> Web-based **single-file** app (HTML + CSS + JS) to generate and visualise CNC G-code with simultaneous 3-axis motion (X, Y, Z) from an STL file.  
> **No server required** — runs entirely in the browser, works offline.

---

## Démo / Demo

Télécharge `gcode3d-generator.html`, ouvre-le dans ton navigateur — c'est tout.  
Download `gcode3d-generator.html`, open it in your browser — that's it.

---

## Fonctionnalités / Features

| Fonctionnalité | Feature |
|---|---|
| Import STL binaire et ASCII | Binary and ASCII STL import |
| Stratégies raster X, Y, croisé | Raster X, Y, crossed toolpaths |
| Parcours 3 axes simultanés (G1 XYZ) | Simultaneous 3-axis motion (G1 XYZ) |
| 5 modes d'origine pièce | 5 workpiece origin modes |
| Visualisation brut (boîte translucide) | Stock block visualisation (translucent box) |
| Compatibilité GRBL, Mach3/4, LinuxCNC | GRBL, Mach3/4, LinuxCNC compatibility |
| Visualisation 3D Three.js (parcours + modèle) | Three.js 3D viewer (toolpath + model) |
| Calcul asynchrone avec barre de progression | Async computation with progress bar |
| Export `.gcode` avec en-tête commenté | `.gcode` export with commented header |
| Interface responsive, thème sombre | Responsive UI, dark theme |

---

## Utilisation / Usage

**FR :**  
1. Télécharge `gcode3d-generator.html`  
2. Ouvre-le dans Chrome, Firefox ou Edge  
3. Charge un fichier STL  
4. Configure les paramètres (outil, avances, broche, pas latéral)  
5. Clique **Générer** → visualise → télécharge le `.gcode`

**EN :**  
1. Download `gcode3d-generator.html`  
2. Open it in Chrome, Firefox or Edge  
3. Load an STL file  
4. Set parameters (tool, feed rates, spindle, step-over)  
5. Click **Generate** → preview → download the `.gcode`

---

## Contrôleurs compatibles / Compatible controllers

- **GRBL** (balises `%`, commentaires `;`)
- **Mach3 / Mach4** (G64 path blending)
- **LinuxCNC** (G21/G90/G94 standard)

---

## Changelog

### v1.3b — [13/06/2026]
- Brut affiché par défaut au lancement (100×100×30 mm) avant tout import STL
- Parcours outil en cyan vif (`#00E5FF`) — meilleure visibilité sur fond sombre
- Longueur du parcours affichée en mm (au lieu de m)
- Commentaires du code enrichis pour faciliter la lecture par un tiers
- Mentions de licence dans l'en-tête de chaque fichier G-code généré

### v1.3 — [11/06/2026]
- Brut 3D translucide avec arêtes dorées, dimensions auto depuis le STL
- 5 modes d'origine pièce (brut, centre XY, coin, coords STL, coords manuelles)
- Correction bug toggle wireframe modèle STL
- Valeurs par défaut usinage : avance 850, plongée 300, broche 14 500 tr/min

### v1.2 — Visualisation 3D
- Visualiseur Three.js r128 : modèle + parcours + axes XYZ
- Support touch (mobile)

### v1.1 — Première version publique
- Génération G-code raster zigzag X/Y/croisé
- Compatibilité GRBL, Mach3/4, LinuxCNC
- Calcul asynchrone avec barre de progression

---

## Road map

Voir [`FONCTIONNALITES.md`](./FONCTIONNALITES.md) pour la liste complète des fonctionnalités prévues (V1.4 → V2.0).  
See [`FONCTIONNALITES.md`](./FONCTIONNALITES.md) for the full feature roadmap (V1.4 → V2.0).

Prochaines étapes prioritaires / Next priority milestones :
- **V1.4** — Multi-passes (profondeur de passe, Z-level / depth per pass, Z-level)
- **V1.5** — Import SVG / DXF (usinage 2D+ / 2.5D machining)
- **V1.6** — Profils machines (machine profiles, localStorage)
- **V1.7** — Bibliothèque de paramètres utilisateur (fichier `.md` local : outils, matériaux, machines / user parameter library via local `.md` file)

---

## Dépendances / Dependencies

| Bibliothèque | Version | Licence | Chargement |
|---|---|---|---|
| [Three.js](https://threejs.org) | r128 | MIT | CDN Cloudflare |

Three.js est la seule dépendance externe. Elle est chargée automatiquement depuis le CDN Cloudflare au premier usage. **Sans connexion internet**, la visualisation 3D ne fonctionnera pas — le G-code est néanmoins généré et exportable normalement.

Pour un usage **100% hors-ligne** : télécharge [`three.min.js`](https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js) et modifie la balise `<script>` dans le HTML pour pointer vers le fichier local.

> Three.js — Copyright © 2010-2024 three.js authors — [MIT License](https://github.com/mrdoob/three.js/blob/dev/LICENSE)

---

Three.js is the only external dependency, loaded automatically from the Cloudflare CDN. **Offline use**: download [`three.min.js`](https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js) and update the `<script>` tag in the HTML to point to the local file. G-code generation works offline regardless.

---

## Licence / License

[MIT](./LICENSE) — libre d'utilisation, de modification et de distribution avec mention de l'auteur.  
Free to use, modify and distribute with attribution.

---

## Auteur / Author

**Marc FONTAINE** — [FabLab BEN](https://www.ben-bordeaux.fr) / [Coop Alpha](https://www.coopalpha.coop)  
Bègles (Gironde, France)

Contributions bienvenues — issues et pull requests ouverts.  
Contributions welcome — issues and pull requests open.
