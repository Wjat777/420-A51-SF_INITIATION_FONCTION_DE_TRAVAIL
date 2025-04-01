# ================================
# Script pour lire un CSV et binariser les données
# ================================

# Lire le fichier CSV
donnees <- read.csv("data_ass_auto.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)

# ----------------------------
# Conversion Oui/Non en 0/1
# ----------------------------
colonnes_binaires <- c("Ind_fumeur", "Ind_util_travail", "Ind_util_affaires", 
                       "Ind_occas", "Ind_vehicule_sport", "Ind_vehicule_loue")

# Appliquer la conversion sur toutes les colonnes Oui/Non
for (colonne in colonnes_binaires) {
  donnees[[colonne]] <- ifelse(donnees[[colonne]] == "Oui", 1, 0)
}

# ----------------------------
# Colonnes catégoriques à binariser
# ----------------------------
colonnes_categoriques <- c("Sexe_assure", "Emploi_assure", "Statut_marital", 
                           "Region", "Couleur_vehicule")

# Installer et charger caret si nécessaire
if (!require("caret")) install.packages("caret", repos = "http://cran.us.r-project.org")
library(caret)

# Appliquer dummyVars pour binariser les variables catégoriques
modele_dummy <- dummyVars(~ Sexe_assure + Emploi_assure + Statut_marital + Region + Couleur_vehicule, 
                          data = donnees, fullRank = FALSE)

# Transformer et binariser les variables catégoriques
donnees_binarisees <- predict(modele_dummy, newdata = donnees)
donnees_binarisees <- as.data.frame(donnees_binarisees)

# ----------------------------
# Combiner avec le reste des données
# ----------------------------
donnees_finales <- cbind(donnees[, !names(donnees) %in% c(colonnes_categoriques)], donnees_binarisees)

# ----------------------------
# Sauvegarder le résultat
# ----------------------------
write.csv(donnees_finales, "donnees_binarisees2.csv", row.names = FALSE)

# Afficher un message de succès
cat("✅ Données binarisées, transformation Oui/Non en 0/1, et fichier sauvegardé avec succès !\n")
