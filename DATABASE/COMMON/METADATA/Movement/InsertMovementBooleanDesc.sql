INSERT INTO MovementBooleanDesc (id, Code ,itemname)
SELECT zc_MovementBoolean_PriceWithVAT(), 'PriceWithVAT','цена с Ќƒ— (да/нет)'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Id = zc_MovementBoolean_PriceWithVAT());

	
--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! Ќќ¬јя —’≈ћј !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
