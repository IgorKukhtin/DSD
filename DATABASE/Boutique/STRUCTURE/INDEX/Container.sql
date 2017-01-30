DROP INDEX IF EXISTS idx_Container_ObjectId_DescId_Id;
DROP INDEX IF EXISTS idx_Container_ParentId_ObjectId_DescId_Id; 
DROP INDEX IF EXISTS idx_Container_Id_ObjectId_DescId;
DROP INDEX IF EXISTS idx_Container_DescId;
DROP INDEX IF EXISTS idx_Container_ObjectId_DescId;
DROP INDEX IF EXISTS idx_Container_ParentId;


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE INDEX idx_Container_ObjectId_DescId ON Container (ObjectId, DescId);
CREATE INDEX idx_Container_DescId ON Container (DescId);
CREATE INDEX idx_Container_ParentId ON Container (ParentId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
10.10.13                              *
19.09.02              * change index
18.06.02                                         
11.07.02                                         
*/
