DROP INDEX IF EXISTS idx_movementlinkobject_movementid_descid_objectid;
DROP INDEX IF EXISTS idx_MovementLinkObject_ObjectId;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



CREATE INDEX idx_MovementLinkObject_ObjectId ON MovementLinkObject(ObjectId); -- для констрейнта

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
