-- Function: gpUpdate_GoodsMain_PublishedSite()

DROP FUNCTION IF EXISTS gpUpdate_GoodsMain_PublishedSite(TFloat, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_GoodsMain_PublishedSite(
    IN inJSON        Text      , -- json     
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    RAISE EXCEPTION 'Загрузка признака разрешена только администратору.';
  END IF;
        
  -- из JSON в таблицу
  CREATE TEMP TABLE tblJSON
  (
     I            Integer,
     P            Integer,
     TU           TVarChar,
     M            TVarChar,
     MU           TVarChar
  ) ON COMMIT DROP;

  INSERT INTO tblJSON
  SELECT *
  FROM json_populate_recordset(null::tblJSON, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
  --raise notice 'Value 05: %', (select Count(*) from tblJSON);      
  
  UPDATE Object_Goods_Main set isPublishedSite = T1.isPublished
                             , NameUkrSite = T1.NameUkrSite
                             , MakerNameSite = T1.MakerNameSite
                             , MakerNameUkrSite = T1.MakerNameUkrSite
                             , DateDownloadsSite = CURRENT_TIMESTAMP
  FROM (SELECT Object_Goods_Retail.GoodsMainId
             , tblJSON.P = 1 AS isPublished
             , tblJSON.TU    AS NameUkrSite
             , tblJSON.M     AS MakerNameSite
             , tblJSON.MU    AS MakerNameUkrSite
        FROM Object_Goods_Retail 
             INNER JOIN tblJSON  ON tblJSON.I = Object_Goods_Retail.Id) AS T1
  WHERE Object_Goods_Main.ID = T1.GoodsMainId
    AND (Object_Goods_Main.isPublishedSite <> T1.isPublished OR Object_Goods_Main.isPublishedSite IS NULL OR
         COALESCE(Object_Goods_Main.NameUkrSite, '') <> COALESCE(T1.NameUkrSite, '') OR
         COALESCE(Object_Goods_Main.MakerNameSite, '') <> COALESCE(T1.MakerNameSite, '') OR
         COALESCE(Object_Goods_Main.MakerNameUkrSite, '') <> COALESCE(T1.MakerNameUkrSite, ''));
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.05.22                                                       *
*/

-- тест 

-- select * from gpUpdate_GoodsMain_PublishedSite(inJSON := '[{"i":325,"p":"1"},{"i":328,"p":"1"},{"i":331,"p":"1"},{"i":334,"p":"1"}]' ,  inSession := '3');
