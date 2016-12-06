changequote(`<', `>')

\documentclass[letterpaper,12pt,final]{article}

\usepackage{datatool}

%% For the lab, we want to number the subsections in roman numerals to
%% follow the assignment
\renewcommand{\thesubsection}{\thesection.\roman{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\alph{subsubsection}}

%%%%%%%%%%%%%%%%%%%%%%%%
%tmp
\usepackage{color}
\newcommand{\hilight}[1]{\colorbox{yellow}{\parbox{\dimexpr\linewidth-2\fboxsep}{#1}}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Détails de langue pour bien supporter le français
%  Accepte les caractères accentués dans le document (UTF-8).
\usepackage[utf8]{inputenc}
% Police de caractères plus complète et généralement indistinguable
% visuellement de la police standard de LaTeX (Computer Modern).
\usepackage{lmodern}
% Bon encodage des caractères pour que les lecteurs de pdf
% reconnaissent les accents et les ligatures telles que ffi.
\usepackage[T1]{fontenc}
% Règles typographiques et d' "hyphenation" propres aux langues
\usepackage[english,frenchb]{babel}


%%%% Packages pour les références
\usepackage{hyperref}
%\usepackage[numbers]{natbib}


%%%% Packages pour l'affichage graphique
% Charge le module d'affichage graphique.
\usepackage{graphicx}
% Recherche des images dans les répertoires.
\graphicspath{{./dia}}
% Un float peut apparaître seulement après sa définition, jamais avant.
\usepackage{flafter}
% Hyperlien vers la figure plutôt que son titre.
\usepackage{caption}
\usepackage{subcaption}
\usepackage{gnuplottex}
\usepackage{geometry}

%% Exemple de figure:
% \begin{figure}[h]
%   \centering
%     \includegraphics[width=\linewidth]{./dia/diagramme.png}
%   \caption{Diagramme de classes du projet}\label{fig:dia_classes}
% \end{figure}



%%%% Packages pour l'affichage de différents types de texte
% Code source:
\usepackage{listings} % Code inline: \lstinline|<code here>|
\lstset{basicstyle=\ttfamily\itshape}
% Symboles mathématiques
\usepackage{amssymb}
% Manipulation de l'espace (page titre)
\usepackage{setspace}
%
% Ligne horizontale pour l'affichage du titre
\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}


%%%% Variables pour le document
% Type de rapport
\newcommand{\monTypeDeRapport}{Rapport de laboratoire}
% Titre du document
\newcommand{\monTitre}{TP3}
% Auteurs
\newcommand{\mesAuteurs}{Jean-Alexandre Barszcz, Benjamin Cotton}
\newcommand{\mesAuteursX}{}
% Sigle du cours
\newcommand{\monCoursX}{INF4705}
% Nom du cours
\newcommand{\monCours}{Analyse et conception d’algorithmes}


%%%% Informations qui sont stockées dans un fichier PDF.
\hypersetup{
  pdftitle={\monTitre},
  pdfsubject={\monCours},
  pdfauthor={\mesAuteurs},
  bookmarksnumbered,
  pdfstartview={FitV},
  hidelinks,
  linktoc=all
}



\begin{document}
    %% Page titre du rapport
    \begin{titlepage}
      \begin{center}

        \begin{doublespace}

          \vspace*{\fill}
          \textsc{ \large \monTypeDeRapport}
          \vspace*{\fill}

          \HRule \\ [5mm]
          {\huge \bfseries \monTitre}\\ [3mm]
          \HRule \\
          \vspace*{\fill}

          \begin{onehalfspace} \large
            \mesAuteursX
          \end{onehalfspace}

          \vfill
          { \Large Cours \monCoursX \\ \monCours } \\

          \today

        \end{doublespace}
      \end{center}
    \end{titlepage}

\newpage

%% Insertion d'une table des matières
%  Cette ligne peut être enlevée si l'on ne 
%  veut pas de table des matières.
\tableofcontents\newpage

\section{Introduction}

Ce dernier travail du cours d’analyse et conception d’algorithmes
consistait à concevoir un algorithme pour résoudre un problème
combinatoire difficile. Le travail est en fait un concours du meilleur
algorithme entre les étudiants de la classe. Le problème à résoudre
est le suivant : faire la composition des tables d’un diner-causerie
de la Chambre de commerce de St-X en s’assurant de minimiser
l’écart-type du nombre de personnes par table et de maximiser le
nombre de compagnies heureuses des personnes assises à leur table. Les
seules conditions à respecter sont que toutes les compagnies doivent
être assises, que toutes les personnes d’une même compagnie doivent
être assises à la même table et que certaines compagnies ne doivent
absolument pas être assises ensemble.  L'algorithme peut fournir
plusieurs solutions et le but est qu'il finisse avec la meilleure à la
fin des trois minutes allouées au calcul.

Afin de concevoir un algorithme pour résoudre ce problème, nous avons
écrit plusieurs prototypes par la suite comparés approximativement
pour choisir un celui qui convient le mieux au problème.

Les prochaines sections décrivent les décisions de conception de
l'algorithme retenu ainsi que son pseudocode et une analyse théorique
de sa complexité.

\section{Code}

Le code du projet contient une librairie de base dans le répertoire
\lstinline|common| qui établit l'interface des algorithmes prototypes
ainsi que les structures de base exprimant le problème, les solutions,
et un moyen d'évaluer la qualité des solutions.  Le répertoire
\lstinline|evalSolution| contient un programme simple qui permet
d'évaluer le flot de solutions donné en entrée.  Finalement, on
retrouve les algorithmes implémentés et un programme qui remplit
essentiellement les requis du script \lstinline|tp.sh| dans le
répertoire \lstinline|runAlgo|.  Comme nous sommes intéressés non
seulement par le comportement asymptotique mais par le temps absolu
requis à nos programmes, nous avons choisit de faire l'implantation en
\textit{C++} pour éviter les surcoûts inutiles.

\section{Jeux de données}

\hilight{TODO}

\section{Choix de conception}

Le problème n'est pas simple et ne montre pas de façon évidente de
sous-structure optimale ou bien de chevauchement.  De plus, une partie
du problème consiste à placer les compagnie parmi $N$ tables sans que
certaines paires soient ensemble.  Autrement dit, il faut partitionner
les sommets du graphes en $N$ sous-ensembles de façon à éviter que
deux sommets adjacents (dans le graphe des liens à éviter) ne soient
dans le même ensemble.  C'est le problème de coloration de graphe qui
dont les meilleurs algorithmes exacts sont de complexité
exponentielle.  Ainsi, notre problème requiert sans doute une solution
suboptimale.  De plus, il faut trouver une solution en moins de trois
minutes. Ainsi, il est judicieux de trouver une solution initiale le
plus rapidement possible et d'améliorer sa qualité progressivement
pour être certain d'avoir une solution dans les contraintes
temporelles fixées.

Pour ces raisons, nous avons démarré avec un algorithme vorace
constructif de coloration de graphe, en le modifiant pour utiliser une
heuristique favorisant la qualité de la solution.  Une fois la
première solution trouvée, on utilise une heuristique locale pour
l'améliorer en utilisant comme voisinage des configurations de tables
celles dont on déplace une compagnie d'une table à une autre.

L'heuristique généralement utilisé pour choisir la table où l'on veut
placer une compagnie est de prendre la table pour laquelle:

\begin{enumerate}
\item On minimise le poid ajouté associé aux souhaits des compagnies.
\item On minimise la différence entre le nombre de personnes déjà à la
  table et la moyenne du nombre de personnes par table. Cette
  différence n'est pas prise en valeur absolue. Prise seule elle
  choisirait la table ayant le moins de personnes.
\end{enumerate}

La première partie de l'heuristique permet de respecter le plus
possible les choix des compagnies, et la seconde vise à minimiser
l'écart-type du nombre de personnes par table. Cependant, un
écart-type dépend de toutes les tables, alors que le nombre de
personnes de la solution finale aux autres tables n'est pas
connu. Ainsi, il faut faire une approximation de ce facteur, et nous
avont choisi de considérer la moyenne des écarts à la moyenne comme
approximation de l'écart-type.

La formule qu'on utilise est donc:
\begin{equation}
  \begin{split}
    Coût(compagnie, table) & = PoidsAjouté(compagnie, table) \\
    & + NbPersonnes(table) - NbPersonnesParTable
    \end{split}
\end{equation}

Pour le raffinement local, on choisit une compagnie au hasard de la
table la plus populée pour la déplacer à une table choisie selon
l'heuristique ci-haut.

Les détails de chacunes de ces étapes se trouvent à la section
suivante.

\section{Analyse théorique}

On décrit ici le pseudocode et l'analyse de complexité de chacune des
parties de notres algorithme, en expliquant aussi quelles structures
de données on été choisies.

\subsection{Solution initiale}

Afin d'obtenir une solution initiale qui respecte la contrainte que
certaines compagnies ne peuvent pas être ensemble, on implante un
algorithme vorace qui place une compagnie à la fois dans le moins de
tables possible. Ce faisant, si plusieurs tables sont possibles pour
une compagnie, on applique l'heuristique mentionnée plus haut. S'il
n'y a pas de table existante dans laquelle on pourrait ajouter la
nouvelle compagnie, on lui crée une nouvelle table.  Si le nombre de
tables dépasse le nombre de tables donné avec le problème, soit il n'y
a pas de solution possible, ou notre algorithme vorace a échoué.

Le pseudocode est décrit à la figure ...

\subsection{Première amélioration}

\subsection{Heuristique d'amélioration locale}

\section{Originalité}

\section{Conclusion}

En conclusion, nous avons eu l'occasion de pratiquer l'application de
patrons de conception algorithmique et d'écrire un algorithme dont le
temps d'exécution est borné d'avance.  Aussi, ce exercice nous a
permit de pratiquer l'analyse d'algorithmes et de l'intégrer dans un
cadre de conception.  De plus, nous avons réussi à trouver une
solution au problème posé.  La solution que nous proposons peut encore
être améliorée cependant dans chacune de ses étapes.

\clearpage
%\bibliographystyle{plainnat} %% or perhaps IEEEtranN
%\bibliography{rapport}

\end{document}
