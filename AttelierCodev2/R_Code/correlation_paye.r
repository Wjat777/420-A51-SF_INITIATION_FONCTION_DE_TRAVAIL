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
# Afficher la corrélation UNIQUEMENT avec Montant_paye
# ----------------------------
# Sélectionner les corrélations avec Montant_paye
correlation_paye <- matrice_correlation["Montant_paye", ]

# Supprimer la propre corrélation de Montant_paye avec lui-même (1.00)
correlation_paye <- correlation_paye[!names(correlation_paye) %in% "Montant_paye"]

# ----------------------------
# Trier les corrélations
# ----------------------------
correlation_ordonnee <- sort(correlation_paye, decreasing = TRUE)

# Afficher les 10 variables les plus corrélées avec Montant_paye
cat("✅ Top 10 des variables les plus corrélées avec Montant_paye :\n")
print(head(correlation_ordonnee, 10))

# ----------------------------
# Sauvegarder les résultats dans un fichier CSV
# ----------------------------
resultat_correlation <- data.frame(Variable = names(correlation_ordonnee), Correlation = correlation_ordonnee)
write.csv(resultat_correlation, "correlation_montant_paye.csv", row.names = FALSE)
