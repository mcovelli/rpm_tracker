CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `restaurant`.`recipe_to_purchase_conversion` AS
    SELECT 
        `restaurant`.`lpp`.`supplier_id` AS `supplier_id`,
        `s`.`supplier_name` AS `supplier_name`,
        `restaurant`.`lpp`.`location_id` AS `location_id`,
        `l`.`location_name` AS `location_name`,
        `ri`.`recipe_id` AS `recipe_id`,
        `r`.`recipe_name` AS `recipe`,
        `ri`.`ingredient_id` AS `ingredient_id`,
        `i`.`ingredient_name` AS `ingredient`,
        `ri`.`ingredient_quantity` AS `quantity`,
        `ri`.`ingredient_unit` AS `recipe_unit`,
        `ru`.`unit_name` AS `recipe_unit_name`,
        CONVERT_INGREDIENT(`ri`.`ingredient_id`,
                `ri`.`ingredient_quantity`,
                `ri`.`ingredient_unit`,
                `restaurant`.`lpp`.`unit_id`) AS `converted_quantity`,
        `restaurant`.`lpp`.`unit_id` AS `purchase_unit`,
        `pu`.`unit_name` AS `purchase_unit_name`
    FROM
        (((((((`restaurant`.`recipe_ingredients` `ri`
        JOIN `restaurant`.`latest_purchase_price` `lpp` ON ((`ri`.`ingredient_id` = `restaurant`.`lpp`.`ingredient_id`)))
        JOIN `restaurant`.`unit` `ru` ON ((`ri`.`ingredient_unit` = `ru`.`unit_id`)))
        JOIN `restaurant`.`unit` `pu` ON ((`restaurant`.`lpp`.`unit_id` = `pu`.`unit_id`)))
        JOIN `restaurant`.`recipe` `r` ON ((`ri`.`recipe_id` = `r`.`recipe_id`)))
        JOIN `restaurant`.`supplier` `s` ON ((`restaurant`.`lpp`.`supplier_id` = `s`.`supplier_id`)))
        JOIN `restaurant`.`location` `l` ON ((`restaurant`.`lpp`.`location_id` = `l`.`location_id`)))
        JOIN `restaurant`.`ingredient` `i` ON ((`ri`.`ingredient_id` = `i`.`ingredient_id`)))
    ORDER BY `ri`.`recipe_id`