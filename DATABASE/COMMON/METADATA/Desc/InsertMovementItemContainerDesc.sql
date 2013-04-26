insert into MovementItemContainerDesc(Id, Code, ItemName)
SELECT zc_MovementItemContainer_Money(), 'Money', '‘мнансовые проводки' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Id = zc_MovementItemContainer_Money());

