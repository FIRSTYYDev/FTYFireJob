INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_pompier', 'Pompier', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_pompier', 'Pompier', 1);

INSERT INTO `jobs` (`name`, `label`) VALUES
('pompier', 'Pompier');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('pompier', 0, 'stage', 'Stagiaire', 100, '', ''),
('pompier', 1, 'confirmee', 'Confirmé échelle', 100, '', ''),
('pompier', 2, 'confirmes', 'Confirmé secours', 100, '', ''),
('pompier', 3, 'lieu', 'Lieutenant', 100, '', ''),
('pompier', 4, 'cb', 'Chef de bataillon', 100, '', ''),
('pompier', 5, 'boss', 'Commandant', 100, '', '');

INSERT INTO `datastore` (name, label, shared) VALUES

	('society_pompier', 'Pompier', 1)

;