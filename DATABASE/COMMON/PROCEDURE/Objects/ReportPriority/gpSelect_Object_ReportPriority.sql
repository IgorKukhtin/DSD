-- Function: gpSelect_Object_ReportPriority()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportPriority (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportPriority(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReportPriority());

      RETURN QUERY
        SELECT 0                                  :: Integer  AS Id
             , 1                                  :: Integer  AS Code
             , 'gpComplete_Movement_Inventory'    :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 2                                  :: Integer  AS Code
             , 'gpReComplete_Movement_Inventory'  :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 3                                  :: Integer  AS Code
             , 'gpReport_MotionGoods'             :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 4                                  :: Integer  AS Code
             , 'gpReport_GoodsBalance'            :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 5                                  :: Integer  AS Code
             , 'gpReport_GoodsBalance_Server'     :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 6                                  :: Integer  AS Code
             , 'gpUpdate_Movement_ReturnIn_Auto'  :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 7                                  :: Integer  AS Code
             , 'gpSelect_Movement_Reestr'         :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 8                                  :: Integer  AS Code
             , 'gpSelect_Object_ReportCollation'  :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 9                                  :: Integer  AS Code
             , 'gpReport_Goods'                   :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 10                                 :: Integer  AS Code
             , 'gpReport_Transport'               :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
             
       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 11                                 :: Integer  AS Code
             , 'gpReport_JuridicalCollation'      :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 12                                 :: Integer  AS Code
             , 'gpUpdateMI_OrderInternal_AmountPartnerPromo' :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 13                                 :: Integer  AS Code
             , 'gpReport_ReceiptAnalyze'          :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 14                                 :: Integer  AS Code
             , 'gpReport_AccountMotion'           :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 15                                 :: Integer  AS Code
             , 'gpReport_Account'                 :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 16                                 :: Integer  AS Code
             , 'gpReport_GoodsMI_Internal'        :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 17                                 :: Integer  AS Code
             , 'gpInsertUpdate_SheetWorkTime_FromTransport' :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 18                                 :: Integer  AS Code
             , 'gpUpdate_MI_PersonalService_Compensation' :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
             
       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 19                                 :: Integer  AS Code
             , 'gpReport_JuridicalBalance'        :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
             
       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 20                                 :: Integer  AS Code
             , 'gpComplete_Movement_PersonalService'        :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased

       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 21                                 :: Integer  AS Code
             , 'gpReComplete_Movement_PersonalService'        :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
             
       UNION ALL
        SELECT 0                                  :: Integer  AS Id
             , 22                                 :: Integer  AS Code
             , 'gpUpdate_Status_PersonalService'        :: TVarChar AS Name
             , FALSE                              :: Boolean  AS isErased
             
             
             
             

        ORDER BY 2
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
  28.04.17                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReportPriority (inSession:= zfCalc_UserAdmin())
