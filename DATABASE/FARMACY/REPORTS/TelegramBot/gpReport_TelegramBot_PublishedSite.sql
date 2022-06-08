-- Function: gpReport_TelegramBot_PublishedSite()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_PublishedSite (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_PublishedSite(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMessage Text;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);
   
    IF EXISTS (SELECT 1
               FROM Object_Goods_Main
               WHERE Object_Goods_Main.isPublished <> Object_Goods_Main.isPublishedSite
                  OR Object_Goods_Main.isPublished = True AND Object_Goods_Main.isPublishedSite IS NULL)
    THEN
      RETURN QUERY
      SELECT '���� ����������� ����� ���������� ����������� �� ����� � � ����.';
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�. 
 06.04.22                                                       * 
*/

-- ����
-- 

SELECT * FROM gpReport_TelegramBot_PublishedSite(inSession := '3');