-- Function: gpSelect_MovementItem_PretensionFile()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PretensionFile (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PretensionFile(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Number Integer, FileName TVarChar, FileFullName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbMovementIncomeId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    
      RETURN QUERY
          WITH 

           PretensionFile AS (SELECT MI_PretensionFile.Id
                                   , ROW_NUMBER() OVER (ORDER BY MI_PretensionFile.Id)::Integer AS Number
                                   , zfExtract_FileName(MIString_FileName.ValueData)            AS FileName
                                   , MIString_FileName.ValueData                                AS FileFullName
                                   , MI_PretensionFile.isErased
                              FROM Movement AS Movement_Pretension
                                   INNER JOIN MovementItem AS MI_PretensionFile
                                                           ON MI_PretensionFile.MovementId = Movement_Pretension.Id
                                                          AND MI_PretensionFile.DescId     = zc_MI_Child()

                                   LEFT JOIN MovementItemString AS MIString_FileName
                                                                ON MIString_FileName.MovementItemId = MI_PretensionFile.Id
                                                               AND MIString_FileName.DescId = zc_MIString_FileName()

                              WHERE Movement_Pretension.Id = inMovementId
                             )

          SELECT
              MovementItem.Id
            , MovementItem.Number  
            , MovementItem.FileName
            , MovementItem.FileFullName
            , MovementItem.isErased
      FROM PretensionFile AS MovementItem
      WHERE (MovementItem.isErased  = FALSE OR inIsErased = TRUE)
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.12.21                                                       *
 
*/

-- тест
select * from gpSelect_MovementItem_PretensionFile(inMovementId := 8086637 ,inIsErased := 'False' ,  inSession := '3');