# GCode 3D Generator — Documentation fonctionnelle

> Application web single-file (HTML + CSS + JS) de génération et de visualisation de G-code pour usinage CNC 3 axes simultanés (X, Y, Z).
> Aucun serveur requis — tout tourne dans le navigateur.

**Fichier principal :** `gcode3d-generator.html`
**Version actuelle :** v1.3 — [11/06/2026]
**Compatibilité :** Chrome, Firefox, Edge (navigateurs modernes)

---

## Fonctionnalités actuelles

### 1. Import du modèle 3D

- Chargement de fichiers **STL binaire** et **STL ASCII** via l'interface
- Détection automatique du format (binaire / ASCII)
- Affichage immédiat des dimensions X × Y × Z (mm) et du nombre de triangles
- Calcul automatique de la boîte englobante (bounding box)

### 2. Paramètres d'outil

- **Diamètre** de l'outil (mm), saisie libre
- **Type d'outil** : bout sphérique (*ball-end*) ou bout plat (*flat-end*)
- **Pas latéral** réglable en pourcentage du diamètre (%) — valeur en mm calculée automatiquement

### 3. Paramètres de coupe

- **Vitesse d'avance XY** (mm/min)
- **Vitesse de plongée Z** (mm/min)
- **Vitesse de broche** (tr/min)
- **Hauteur de sécurité Z** (mm) — utilisée pour les déplacements rapides entre passes

### 4. Stratégies de balayage

- **Raster X** — lignes parallèles dans la direction X (→)
- **Raster Y** — lignes parallèles dans la direction Y (↑)
- **Croisé X + Y** — double balayage (réduit les stries d'usinage)
- Sens alternés automatiques (zigzag) pour limiter les retours à vide

### 5. Définition de l'origine pièce (X0 Y0 Z0)

Quatre modes disponibles :

| Mode | Description |
|------|-------------|
| Centre XY — sommet Z0 | Centre horizontal de la pièce, sommet = Z0 (le plus courant) |
| Coin avant-gauche — sommet Z0 | Coin bas-gauche XY, sommet = Z0 |
| Coordonnées STL brutes | Pas de décalage — coordonnées du fichier STL conservées |
| **Coordonnées manuelles XYZ** | Saisie libre des coordonnées STL du point X0 Y0 Z0 souhaité |

Le mode manuel affiche la plage de coordonnées du modèle en référence et pré-remplit avec le centre-sommet.

### 6. Compatibilité contrôleurs

G-code généré adapté selon le contrôleur cible :

- **GRBL** — balises `%`, commentaires `;`, sans lissage de trajectoire
- **Mach3 / Mach4** — `G64 P0.025 Q0.025` pour le lissage de trajectoire (path blending)
- **LinuxCNC** — format standard G21/G90/G94

### 7. Génération du parcours outil

- Algorithme de **lancé de rayons verticaux** sur la surface STL
- **Grille spatiale d'accélération** 30×30 cellules (évite les O(N²) bruts)
- Calcul **asynchrone** avec barre de progression (pas de gel de l'interface)
- Déplacements simultanés **G1 X Y Z** (vrai 3 axes simultanés)
- Gestion des trous de surface (levée d'outil automatique)
- Taux de feed modal (F émis uniquement quand il change)

### 8. Statistiques de sortie

Affichées après génération :

- Nombre total de points de trajectoire
- Nombre de déplacements G1 XYZ simultanés
- Nombre de lignes G-code
- Longueur totale du parcours (m)
- Temps d'usinage estimé (avance seule, en minutes)
- Résolution de la grille (N × N points/ligne)

### 9. Export G-code

- Téléchargement du fichier `.gcode` — nom automatique d'après le fichier STL source
- En-tête commenté : date, outil, avances, broche, hauteur de sécurité, nombre de points
- Structure : mise en place → parcours → fin de programme (M5, M30)

### 10. Visualisation 3D

- Moteur **Three.js r128** (chargé depuis CDN Cloudflare)
- Modèle STL affiché en **mesh semi-transparent** + wireframe
- **Parcours outil** en ligne colorée dégradé vert → rouge (ordre chronologique)
- **Axes XYZ** avec flèches et labels (X rouge, Y vert, Z bleu) positionnés sur l'origine WCS active — visibles par-dessus la géométrie
- **Grille de référence** adaptée à la taille du modèle
- Contrôles souris : orbite (clic gauche), pan (clic droit / Ctrl+clic), zoom (molette)
- Support tactile : rotation 1 doigt, pinch zoom 2 doigts
- Toggles d'affichage indépendants : modèle / parcours / axes

---

## Format G-code produit — exemple type

```gcode
%
; =====================================================
; G-Code 3D — Usinage simultané XYZ
; Généré le : 11/06/2026 à 14:32
; Outil     : Bout sphérique Ø6 mm
; Avance    : 800 mm/min | Plongée : 200 mm/min
; Broche    : 12000 tr/min | Sécurité Z : 5 mm
; =====================================================

G21       ; millimètres
G90       ; coordonnées absolues
G94       ; avance en mm/min

T1 M6
S12000 M3
G4 P2.0
G0 Z5.000
G0 X0.000 Y0.000

G0 X-25.000 Y-30.000
G1 Z-1.240 F200
G1 X-24.600 Y-30.000 Z-1.185 F800   ← déplacement simultané XYZ
G1 X-24.200 Y-30.000 Z-1.092 F800
...

G0 Z5.000
G0 X0.000 Y0.000
M5
M30
%
```

---

## Limitations connues (v1.1)

| Limitation | Impact | Contournement |
|------------|--------|---------------|
| Pas de compensation de rayon d'outil (TRC) | Le G-code suit la surface à la pointe — correct pour bout sphérique finition ; peut laisser des surépaisseurs avec un bout plat sur des parois | Utiliser un bout sphérique pour la finition 3D |
| Pas d'interpolation d'arcs G2/G3 | Non nécessaire pour le raster XYZ pur | — |
| Calcul JS mono-thread | Sur un STL complexe (>100k triangles) + petit pas, le calcul peut dépasser 15 s | Augmenter le pas latéral pour réduire le nombre de points |
| Dépendance CDN Three.js | Ne fonctionne pas offline si Three.js n'est pas chargé localement | Télécharger `three.min.js` et modifier la balise `<script>` |

---

## Road map — fonctionnalités futures

### 🔵 Priorité haute

#### V1.2 — Simulateur G-code (style NCViewer)
- [ ] Import / collage d'un fichier G-code existant (pas seulement celui généré dans la session)
- [ ] Parser G-code : G0 (rapide), G1 (coupe linéaire), gestion des modales F/S
- [ ] Visualisation 3D distincte : **G0 en jaune pointillé**, G1 en dégradé coloré
- [ ] **DRO (Digital Read Out)** : affichage X / Y / Z en temps réel pendant la simulation
- [ ] Simulation animée : boutons ▶ Lecture / ⏸ Pause / ⏮ Début / ⏭ Fin
- [ ] Curseur de progression sur la timeline du G-code
- [ ] Surbrillance de la ligne G-code active dans un panneau texte

#### V1.3 — Gestion du brut et de l'origine

La notion de **brut** est le bloc de matière réelle dans lequel la pièce sera usinée. Elle est distincte du modèle STL et conditionne l'origine, les passes d'ébauche et la sécurité des déplacements.

- [ ] **Définition du brut** : saisie des dimensions Longueur × Largeur × Hauteur (mm) indépendamment du modèle STL
- [ ] **Visualisation du brut** dans la vue 3D : boîte semi-transparente englobant le modèle, cotée sur les trois axes
- [ ] **Positionnement du modèle dans le brut** : centrage automatique ou décalage manuel (X, Y, Z), avec prévisualisation en temps réel
- [ ] **Origines liées au brut** (extension du système d'origine actuel) :
  - Sommet du brut = Z0 (mode standard, coin avant-gauche ou centre XY)
  - Bas du brut = Z0 (pour les machines où on pose la pièce sur la table)
  - Bas du brut + hauteur brut = Z0 (revient au sommet, mais calculé depuis le bas)
- [ ] **Surépaisseur de matière** (stock allowance) : laisser N mm non usinés pour une passe de finition ultérieure
- [ ] **Alerte de dépassement** : signal visuel si le modèle STL sort des limites du brut défini

#### V1.4 — Stratégie multi-passes et profondeur de passe

- [ ] **Profondeur de passe (ap)** : diviser automatiquement l'usinage en N passes à profondeur Z croissante
  - Ex. : pièce de 20 mm, ap = 5 mm → 4 passes à Z = −5 / −10 / −15 / −20
- [ ] **Ordre des passes** : du haut vers le bas (descente progressive dans la matière)
- [ ] **Combinaison ébauche multi-passes + finition raster 3D** en une seule génération
- [ ] **Passes horizontales à Z constant** (stratégie Z-level / waterline) pour les ébauches de formes complexes
- [ ] **Limitation de la zone d'usinage** (XY min/max) pour ne traiter qu'une région du brut
- [ ] **Vitesse réduite automatique** dans les zones de forte variation Z (coins, arêtes vives)

#### V1.5 — Import SVG et DXF (usinage 2D+)

Le **2D+** (ou 2,5D) désigne l'usinage de profils 2D avec une profondeur Z contrôlée : découpe de contours, poches, gravure. Les fichiers SVG et DXF sont les formats standards pour ces géométries issues de la conception (Inkscape, FreeCAD, AutoCAD, Illustrator…).

##### Import des fichiers
- [ ] **Import SVG** : lecture des chemins (`<path>`, `<polyline>`, `<rect>`, `<circle>`, `<ellipse>`) comme contours 2D
- [ ] **Import DXF** : entités LINE, LWPOLYLINE, ARC, CIRCLE, SPLINE (format DXF R12 / R14 / 2000)
- [ ] **Visualisation 2D** des contours importés dans la vue 3D (plan XY du brut), avec distinction par couleur selon la stratégie assignée

##### Stratégie Contour — position de l'outil sur le trait
Lors d'une découpe de contour, la position du centre de l'outil par rapport au trait de coupe doit être explicitement choisie. Ce choix détermine la cote finale de la pièce.

- [ ] **Sur le trait** (*on-path*) — centre de l'outil exactement sur le tracé, aucune compensation. Utilisé pour la gravure et les tracés décoratifs.
- [ ] **À l'intérieur du trait** (*inside / G41*) — l'outil se décale vers l'intérieur du contour d'une valeur = rayon d'outil. La matière intérieure est préservée (mode pièce mâle / découpe extérieure).
- [ ] **À l'extérieur du trait** (*outside / G42*) — l'outil se décale vers l'extérieur. La matière extérieure est préservée (mode poche / découpe intérieure).
- [ ] Compensation géométrique calculée côté logiciel (pas de G41/G42 machine) pour une compatibilité maximale avec tous les contrôleurs.

##### Stratégie Poche — méthodes de remplissage
Une poche consiste à évider l'intérieur d'un contour fermé. Trois méthodes de remplissage disponibles :

- [ ] **Fil / Contour parallèle** (*follow / offset-in*) — l'outil suit le contour puis se rapproche progressivement du centre par décalages successifs (offset). Donne de bonnes finitions de paroi. Paramètre : pourcentage de recouvrement entre passes.
- [ ] **Offset concentrique** (*offset pocket*) — variante du fil avec un pas latéral constant et un chemin lissé pour éviter les arrêts en coin. Adapté aux fraiseuses à faible rigidité.
- [ ] **Tram X** (*raster X*) — balayage en lignes parallèles à l'axe X, sens alternés (zigzag). Simple et rapide à calculer. Paramètre : pas latéral (mm ou % du diamètre).
- [ ] **Tram Y** (*raster Y*) — même principe, lignes parallèles à l'axe Y.
- [ ] Choix du **sens de fraisage** : en opposition (*conventional milling*) ou en avalant (*climb milling*) — impacte la durée de vie de l'outil et la qualité de surface.
- [ ] **Gestion de l'ordre des passes** : poches avant contours (*inside-out*) pour éviter les chutes de matière.

##### Méthodes de pénétration dans la matière
La façon dont l'outil descend dans la matière est critique : une plongée verticale directe peut casser l'outil, surtout sur des fraises en bout sans taille au centre.

- [ ] **Plongée verticale** (*vertical plunge*) — descente G1 Z droite. Acceptable pour les forets et les fraises à taille au centre. Vitesse de plongée distincte (déjà implémentée).
- [ ] **Rampe linéaire** (*linear ramp*) — l'outil descend en diagonale en avançant simultanément en XY. Angle de rampe paramétrable : **5° / 10° / 20°** ou valeur libre. Réduit la charge axiale. La longueur de rampe est calculée automatiquement en fonction de l'angle et de la profondeur de passe.
- [ ] **Hélice** (*helical entry*) — descente en spirale circulaire autour du point d'entrée. Le rayon de l'hélice est paramétrable (% du diamètre outil). Méthode la plus douce, recommandée pour les aciers et les matériaux durs.
- [ ] Choix de la méthode de pénétration **par stratégie** (contour, poche) et **par matériau** (préréglages : bois, aluminium, acier).

##### Autres fonctionnalités 2D+
- [ ] **Profondeur par passe** sur les contours 2D (compatible V1.4)
- [ ] **Gravure** : suivre le tracé à profondeur constante, sans compensation de rayon
- [ ] **Tabs / ponts de maintien** : pontets non découpés pour maintenir la pièce jusqu'à la dernière passe — position, largeur et hauteur paramétrables

### 🟡 Priorité moyenne

#### V1.6 — Gestion des machines (profils CNC)

Permettre de sauvegarder et sélectionner un profil machine, évitant de re-saisir les paramètres à chaque session.

- [ ] **Nom de la machine** : libellé libre (ex. : "CNC BEN Routeur", "Graveur laser", "Mini CNC perso")
- [ ] **Surface de travail** : dimensions X × Y × Z max (mm) — servira à valider que la pièce + brut rentrent dans la course machine
- [ ] **Type de broche** :
  - *Manuelle* — vitesse réglée à la main, pas de M3/S dans le G-code
  - *Pilotée* — commande numérique, M3 S{RPM} généré normalement
- [ ] **Vitesse max de broche** (tr/min) — limite haute affichée comme plafond dans le champ broche
- [ ] Sélecteur de profil en tête de panneau — chargement instantané des paramètres par défaut associés
- [ ] Stockage local (`localStorage`) — les profils persistent entre sessions
- [ ] Détection automatique si la pièce + brut dépassent la surface de travail de la machine sélectionnée

#### V1.7 — Améliorations de l'interface
- [ ] Sauvegarde / rechargement des réglages (JSON local, `localStorage`)
- [ ] Prévisualisation du nombre de points estimé avant calcul (avertissement si trop long)
- [ ] Outil de mesure dans la vue 3D (distance entre deux points cliqués)
- [ ] Vue en coupe Z (plan de coupe glissant)

### 🟢 Priorité basse / expérimental

#### V2.0 — Fonctionnalités avancées
- [ ] Interpolation d'arcs G2/G3 dans le parser G-code
- [ ] Mode tour (axe de rotation, diamètre)
- [ ] Export SVG du plan de vue (trace 2D du parcours)
- [ ] Bundling offline : intégrer Three.js directement dans le HTML (auto-suffisant)
- [ ] Partage de projet par URL (paramètres encodés dans le hash)
- [ ] Internationalisation (EN/FR toggle)

---

## Structure du fichier source

```
gcode3d-generator.html
├── <style>          Thème sombre, mise en page deux colonnes
├── <body>
│   ├── #panel       Panneau gauche : tous les contrôles
│   └── #viewer      Zone droite : canvas Three.js
└── <script>
    ├── 1. STL Parser         parseBinarySTL / parseAsciiSTL
    ├── 2. SpatialGrid        Grille d'accélération pour le lancé de rayons
    ├── 3. Ray-Triangle       hitZ / surfaceZ
    ├── 4. buildToolpath()    Générateur raster zigzag (async)
    ├── 5. writeGCode()       Sérialisation en texte G-code
    ├── 6. Viewer3D           Classe Three.js : scène, caméra, axes, interactions
    └── 7. UI Controller      Événements, état, coordination

── À venir (évolutions prévues) ──
    ├── 8. StockManager       Brut : dimensions, positionnement modèle, visualisation
    ├── 9. MultipassPlanner   Découpage en passes par profondeur (ap)
    ├── 10. GCodeSimulator    Parser + animateur G-code (DRO, play/pause)
    ├── 11. SVGParser         Import et extraction de contours SVG
    └── 12. DXFParser         Import DXF (LINE, LWPOLYLINE, ARC, CIRCLE)
```

---

*Document maintenu par Marc FONTAINE — FabLab BEN / Coop Alpha*
*Dernière mise à jour : [11/06/2026] — V1.3 livrée (brut, origine, corrections) ; V1.6 profils machines ajoutée à la road map*
