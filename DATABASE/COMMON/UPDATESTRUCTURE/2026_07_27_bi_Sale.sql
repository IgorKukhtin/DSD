DO $$ 
    BEGIN
    
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale_2025') AND Column_Name = lower('Amount_promo_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale_2025 ADD COLUMN Amount_promo_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale_2025') AND Column_Name = lower('Amount_promo_sh_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale_2025 ADD COLUMN Amount_promo_sh_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale_2025') AND Column_Name = lower('Summ_promo_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale_2025 ADD COLUMN Summ_promo_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale_2025') AND Column_Name = lower('SummCost_promo_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale_2025 ADD COLUMN SummCost_promo_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale_2025') AND Column_Name = lower('isNotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale_2025 ADD COLUMN isNotBudg Boolean;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale_2025') AND Column_Name = lower('PromoId_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale_2025 ADD COLUMN PromoId_NotBudg Integer;
        END IF;

    END;
$$;


DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale') AND Column_Name = lower('Amount_promo'))) THEN
            ALTER TABLE _bi_Table_Report_Sale ADD COLUMN Amount_promo TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale') AND Column_Name = lower('Amount_promo_sh_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale ADD COLUMN Amount_promo_sh_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale') AND Column_Name = lower('Summ_promo_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale ADD COLUMN Summ_promo_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale') AND Column_Name = lower('SummCost_promo_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale ADD COLUMN SummCost_promo_NotBudg TFloat;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale') AND Column_Name = lower('isNotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale ADD COLUMN isNotBudg Boolean;
        END IF;

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('_bi_Table_Report_Sale') AND Column_Name = lower('PromoId_NotBudg'))) THEN
            ALTER TABLE _bi_Table_Report_Sale ADD COLUMN PromoId_NotBudg Integer;
        END IF;

    END;
$$;


