DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('SoldTable') AND Column_Name = lower('GoodsByGoodsKindId'))) THEN
            ALTER TABLE SoldTable ADD COLUMN GoodsByGoodsKindId Integer;
            UPDATE SoldTable SET GoodsByGoodsKindId = 0;
        END IF;

    END;
$$;


