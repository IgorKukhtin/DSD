insert into MovementItemDesc(Id, Code, ItemName)
SELECT zc_MovementItem_Goods(), 'Goods', 'Движение товаров' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Id = zc_MovementItem_Goods());


