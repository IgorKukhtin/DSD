DO $$ 
    BEGIN

        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('Container') AND Column_Name = lower('WhereObjectId'))) THEN
            ALTER TABLE Container ADD COLUMN WhereObjectId Integer;
            CREATE INDEX idx_Container_WhereObjectId_Amount ON Container (WhereObjectId, DescId, Amount, ObjectId);
        update container set WhereObjectId = CLO_Unit.ObjectID
            from containerlinkobject AS CLO_Unit
                                           where CLO_Unit.containerid = container.id 
                                          AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()
                                          and COALESCE(WhereObjectId, 0) <> CLO_Unit.ObjectID;
        END IF;

    END;
$$;
