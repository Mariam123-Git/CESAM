-- Script de données de test/démonstration

-- Insérer des universités
INSERT INTO public.universites (nom, ville, adresse) VALUES
('Université Mohammed V', 'Rabat', 'Avenue des Nations Unies, Rabat'),
('Université Hassan II', 'Casablanca', 'Km 8, Route d''El Jadida, Casablanca'),
('Université Cadi Ayyad', 'Marrakech', 'Avenue Abdelkrim Elkhattabi, Marrakech'),
('Université Sidi Mohammed Ben Abdellah', 'Fès', 'Route d''Imouzzer, Fès'),
('Université Ibn Tofail', 'Kénitra', 'BP 133, Kénitra')
ON CONFLICT (id) DO NOTHING;

-- Insérer des entreprises
INSERT INTO public.entreprise (nom, secteur, ville, contact, description, site_web) VALUES
('Maroc Telecom', 'Télécommunications', 'Rabat', 'contact@iam.ma', 'Opérateur de télécommunications leader au Maroc', 'https://www.iam.ma'),
('Attijariwafa Bank', 'Finance', 'Casablanca', 'info@attijariwafa.com', 'Première banque du Maroc et de l''Afrique de l''Ouest', 'https://www.attijariwafabank.com'),
('OCP Group', 'Chimie/Mines', 'Casablanca', 'contact@ocpgroup.ma', 'Leader mondial sur le marché des phosphates', 'https://www.ocpgroup.ma'),
('BMCE Bank', 'Finance', 'Casablanca', 'info@bmcebank.ma', 'Banque internationale du Maroc', 'https://www.bmcebank.ma'),
('Capgemini Maroc', 'IT/Conseil', 'Casablanca', 'maroc@capgemini.com', 'Services de conseil en technologie', 'https://www.capgemini.com')
ON CONFLICT (id_entreprise) DO NOTHING;

-- Insérer des bourses
INSERT INTO public.bourse (nom, description, montant, type, conditions, date_debut, date_fin) VALUES
('Bourse d''Excellence', 'Bourse destinée aux étudiants excellents', 5000.00, 'Mérite', 'Moyenne générale supérieure à 16/20', '2024-09-01', '2025-06-30'),
('Bourse Sociale', 'Aide financière pour étudiants en difficulté', 3000.00, 'Sociale', 'Revenus familiaux inférieurs à 50000 DH/an', '2024-09-01', '2025-06-30'),
('Bourse de Recherche', 'Soutien aux étudiants chercheurs', 8000.00, 'Recherche', 'Inscription en Master ou Doctorat', '2024-01-01', '2024-12-31'),
('Bourse Internationale', 'Pour études à l''étranger', 15000.00, 'International', 'Admission dans université étrangère partenaire', '2024-06-01', '2024-08-31')
ON CONFLICT (id_bourse) DO NOTHING;

-- Insérer des offres d'emploi/stage
INSERT INTO public.offre (titre, description, type, id_entreprise, date_publication, date_expiration) VALUES
('Stage développement web', 'Stage de 6 mois en développement web avec React et Node.js', 'Stage', 5, '2024-01-15', '2024-12-31'),
('Ingénieur réseau junior', 'Poste d''ingénieur réseau débutant', 'Emploi', 1, '2024-02-01', '2024-12-31'),
('Analyste financier', 'Analyste financier junior pour département risques', 'Emploi', 2, '2024-01-20', '2024-12-31'),
('Stage marketing digital', 'Stage en marketing digital et communication', 'Stage', 4, '2024-02-10', '2024-12-31'),
('Ingénieur chimiste', 'Ingénieur process en industrie chimique', 'Emploi', 3, '2024-01-25', '2024-12-31')
ON CONFLICT (id_offre) DO NOTHING;

-- Insérer des utilisateurs de test (mots de passe à hasher en production)
INSERT INTO public.utilisateur (nom, prenom, email, mot_de_passe, nationalite, niveau_etudes, domaine_etudes, role, date_inscription, email_verifie) VALUES
('Admin', 'Système', 'admin@exemple.com', '$2b$10$hashedpassword', 'Marocaine', 'Master', 'Informatique', 'admin', '2024-01-01', true),
('Alami', 'Ahmed', 'ahmed.alami@exemple.com', '$2b$10$hashedpassword', 'Marocaine', 'Licence', 'Informatique', 'etudiant', '2024-01-15', true),
('Benali', 'Fatima', 'fatima.benali@exemple.com', '$2b$10$hashedpassword', 'Marocaine', 'Master', 'Gestion', 'etudiant', '2024-01-20', true),
('Raji', 'Omar', 'omar.raji@exemple.com', '$2b$10$hashedpassword', 'Marocaine', 'Licence', 'Ingénierie', 'etudiant', '2024-02-01', false)
ON CONFLICT (id_utilisateur) DO NOTHING;

-- Insérer des étudiants de test (table séparée - semble être un ancien système)
INSERT INTO public.etudiants (nom, prenom, email, mot_de_passe, nationalite, date_naissance, universite_id, role) VALUES
('Tazi', 'Youssef', 'youssef.tazi@exemple.com', '$2b$10$hashedpassword', 'Marocaine', '1998-05-15', 1, 'etudiant'),
('Idrissi', 'Aicha', 'aicha.idrissi@exemple.com', '$2b$10$hashedpassword', 'Marocaine', '1999-03-22', 2, 'etudiant'),
('Benjelloun', 'Karim', 'karim.benjelloun@exemple.com', '$2b$10$hashedpassword', 'Marocaine', '1997-11-08', 1, 'etudiant')
ON CONFLICT (id) DO NOTHING;

-- Insérer des projets d'exemple
INSERT INTO public.projet (titre, description, type, id_utilisateu, id_universite, domaine, annee, url) VALUES
('Application de gestion des étudiants', 'Système de gestion complète pour universités', 'Académique', 2, 1, 'Informatique', 2024, 'https://github.com/exemple/gestion-etudiants'),
('Plateforme e-commerce', 'Site de vente en ligne avec paiement intégré', 'Personnel', 3, 2, 'Informatique', 2024, 'https://github.com/exemple/ecommerce'),
('Analyse financière automatisée', 'Outil d''analyse des données financières', 'Recherche', 3, 2, 'Finance', 2024, null)
ON CONFLICT (id_projet) DO NOTHING;

-- Insérer des notifications d'exemple
INSERT INTO public.notifications (id_etudiant, contenu, lu) VALUES
(1, 'Votre candidature pour la bourse d''excellence a été acceptée', false),
(2, 'Nouvelle offre de stage disponible chez Capgemini', false),
(3, 'Rappel: Date limite de candidature pour bourse internationale approche', true)
ON CONFLICT (id) DO NOTHING;

-- Insérer des profils d'exemple
INSERT INTO public.profil (id_utilisateur, competences, description) VALUES
(2, 'JavaScript, React, Node.js, PostgreSQL, Git', 'Étudiant passionné de développement web avec 2 ans d''expérience en projets personnels'),
(3, 'Analyse financière, Excel, Python, SQL', 'Étudiante en finance avec stage en banque d''investissement'),
(4, 'Java, Python, Mathématiques, Algorithmique', 'Étudiant en ingénierie informatique spécialisé en intelligence artificielle')
ON CONFLICT (id_profil) DO NOTHING;

-- Exemple de sauvegardes de bourses
INSERT INTO public.bourse_sauvegarde (id_utilisateur, id_bourse) VALUES
(2, 1),
(2, 3),
(3, 2),
(4, 1)
ON CONFLICT (id_utilisateur, id_bourse) DO NOTHING;