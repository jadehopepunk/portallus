CREATE TABLE `blog_details` (
  `id` int(11) NOT NULL auto_increment,
  `section_id` int(11) default NULL,
  `text` text,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `blog_entries` (
  `id` int(11) NOT NULL auto_increment,
  `section_id` int(11) default NULL,
  `heading` text,
  `text` text,
  `more_text` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `images` (
  `id` int(11) NOT NULL auto_increment,
  `file` text,
  `person_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL auto_increment,
  `section_id` int(11) default NULL,
  `text` text,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `people` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `unique_name` varchar(80) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `title` text,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `persona_details` (
  `id` int(11) NOT NULL auto_increment,
  `section_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `local_group` varchar(255) default NULL,
  `kingdom` varchar(255) default NULL,
  `historical_context` text,
  `awards` text,
  `offices_held` text,
  `site_introduction` text,
  `device` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `relationship_details` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `relationships` (
  `id` int(11) NOT NULL auto_increment,
  `source_id` int(11) default NULL,
  `destination_id` int(11) default NULL,
  `description` varchar(255) default NULL,
  `relationship_details_id` int(11) default NULL,
  `approved` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) TYPE=MyISAM;

CREATE TABLE `section_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(80) default NULL,
  `title` text,
  `description` text,
  `site_type` text,
  `is_singleton` tinyint(1) default NULL,
  `is_user_creatable` tinyint(1) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `sections` (
  `id` int(11) NOT NULL auto_increment,
  `parent_section_id` int(11) default NULL,
  `name` varchar(30) default NULL,
  `position` int(11) default NULL,
  `heading` text,
  `site_id` int(11) default NULL,
  `section_type_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `unique_name` varchar(80) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `title` text,
  `type` varchar(255) default NULL,
  `society_name` text,
  `picture` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `password` varchar(40) default NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

INSERT INTO schema_info (version) VALUES (49)