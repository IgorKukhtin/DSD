-- Function: gpSelect_Object_ReportPriority()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportPriority (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportPriority(
    IN inSession     TVarChar            -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
BEGIN

      -- �������� ���� ������������ �� ����� ���������
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

        ORDER BY 2
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
  28.04.17                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReportPriority (inSession:= zfCalc_UserAdmin())
