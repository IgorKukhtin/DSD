-- Function: lpCheck_Object_CycleLink(integer, integer, integer)

-- DROP FUNCTION lpCheck_Object_CycleLink(integer, integer, integer);

-- Процедура проверяет что бы не было зацикленностей 

CREATE OR REPLACE FUNCTION lpCheck_Object_CycleLink(
 inObjectId               integer,    -- Ссылка на главный объект
 inDescId                 integer,    -- Деск сслыки на родителя
 inObjectParentId         integer     -- Объект Родитель
)
  RETURNS void AS
$BODY$
DECLARE
  DescName TVarChar;
BEGIN     
  IF COALESCE (inObjectId, 0) <> 0 THEN 
     IF EXISTS (WITH RECURSIVE Tree (Id, ParentId) AS 
                   (SELECT ObjectId, ChildObjectId 
                    FROM Objectlink WHERE ObjectId = inObjectParentId AND DescId = inDescId
                   UNION ALL 
                    SELECT ObjectId, ChildObjectId 
                    FROM Objectlink  
                         INNER JOIN Tree ON Tree.ParentId = Objectlink.ObjectId
                    WHERE DescId = inDescId
                   )
                SELECT Id FROM Tree WHERE Id = inObjectId LIMIT 1
               )
     THEN
        SELECT ItemName INTO DescName FROM ObjectLinkDesc WHERE Id = inDescId;
        RAISE EXCEPTION 'Нельзя установить связь "%" из-за циклической ссылки', DescName;
     END IF;
  END IF; 
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheck_Object_CycleLink (integer, integer, integer)  OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.14                                        * Cyr1251
*/

-- тест
-- SELECT * FROM lpCheck_Object_CycleLink (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
