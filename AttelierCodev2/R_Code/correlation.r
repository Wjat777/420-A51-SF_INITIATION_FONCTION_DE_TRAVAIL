# ==================================
# Lire les données binarisées et calculer la corrélation
# ==================================

# Lire le fichier CSV binarisé
donnees <- read.csv("donnees_binarisees2.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

# ----------------------------
# Supprimer les colonnes non pertinentes
# ----------------------------
# Suppression de Index_Sinistre (inutile pour la corrélation)
donnees$Index_Sinistre <- NULL

# ----------------------------
# Calculer la matrice de corrélation
# ----------------------------
# Seulement les variables numériques et binarisées
matrice_correlation <- cor(donnees, use = "complete.obs")

# ----------------------------
# Afficher la corrélation avec Montant_paye
# ----------------------------
correlation_paye <- matrice_correlation["Montant_paye", ]
correlation_ordonnee <- sort(correlation_paye, decreasing = TRUE)

# Afficher les 10 variables les plus corrélées avec Montant_paye
cat("✅ Top 10 des variables les plus corrélées avec Montant_paye :\n")
print(head(correlation_ordonnee, 10))

# ----------------------------
# Sauvegarder la matrice de corrélation
# ----------------------------
write.csv(matrice_correlation, "matrice_correlation.csv", row.names = TRUE)

# ----------------------------
# Générer une carte thermique (heatmap) des corrélations
# ----------------------------
# Installer et charger ggplot2 et reshape2 si nécessaire
if (!require("ggplot2")) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if (!require("reshape2")) install.packages("reshape2", repos = "http://cran.us.r-project.org")

library(ggplot2)
library(reshape2)

# Transformer la matrice en format long pour visualisation
matrice_melt <- melt(matrice_correlation)

# Générer la carte thermique
ggplot(data = matrice_melt, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0,
                       limit = c(-1, 1), space = "Lab", name = "Corrélation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1)) +
  coord_fixed()
