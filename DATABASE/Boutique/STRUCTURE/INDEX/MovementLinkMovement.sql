
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



CREATE INDEX idx_MovementLinkMovement_All ON MovementLinkMovement(MovementId, DescId, MovementChildId); 
CREATE INDEX idx_MovementLinkMovement_MovementChildId ON MovementLinkMovement(MovementChildId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
*/
