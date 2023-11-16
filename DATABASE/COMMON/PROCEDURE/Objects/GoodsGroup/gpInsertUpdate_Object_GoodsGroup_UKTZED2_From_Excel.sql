 -- Function: gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel (TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel(
    IN inGoodsGroupName   TVarChar   ,
    IN inParentName       TVarChar  , -- 
    IN inCodeUKTZED_new   TVarChar  ,
    IN inDateUKTZED_new   TDateTime ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsGroupId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());


     --проверка
     IF COALESCE (inGoodsGroupName,'') = ''
     THEN
         RETURN;
     END IF;


     --проверка
     IF COALESCE (inCodeUKTZED_new,'') = ''
     THEN
         RAISE EXCEPTION 'Ошибка. Новый Код UKTZED не задан для <%>.', inGoodsGroupName; 
     END IF;



     --находим нужную группу по названию и по родителю
     vbGoodsGroupId := (SELECT Object.Id
                        FROM Object
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                                 ON ObjectLink_GoodsGroup.ObjectId = Object.Id
                                                AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
                        WHERE Object.DescId = zc_object_GoodsGroup()
                          AND TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inGoodsGroupName))
                          AND COALESCE (TRIM (UPPER (GoodsGroup.ValueData)),'') = COALESCE (TRIM (UPPER (inParentName)),'')
                        LIMIT 1);
 

     -- Проверка
     IF COALESCE (vbGoodsGroupId,0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.Не найдена группа <%> с родителем = <%>.', inGoodsGroupName, inParentName;
     END IF;

     --проверка чтоб новый код был пустой 
     IF EXISTS (SELECT 1
                FROM ObjectString
                WHERE ObjectString.DescId = zc_ObjectString_GoodsGroup_UKTZED_new()
                  AND ObjectString.ObjectId = vbGoodsGroupId
                  AND COALESCE (ObjectString.ValueData, '') <> ''
                LIMIT 1) 
     THEN 
         RAISE EXCEPTION 'Ошибка. Для группы <%>, родитель = <%>, новый Код UKTZED уже установлен.', inGoodsGroupName, inParentName; 
     END IF;
     

     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED_new(), vbGoodsGroupId, TRIM (inCodeUKTZED_new));
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsGroup_UKTZED_new(), vbGoodsGroupId, inDateUKTZED_new);
   
 
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%>', inGoodsGroupName; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
*/

-- тест
-- select * from gpInsertUpdate_Object_GoodsGroup_UKTZED2_From_Excel( 'круг' ::TVarChar, 'сырье оболочка':: TVarChar, '5555xcsxcsc'::TVarChar,'15.11.2023' ::TDateTime, '9457'::TVarChar)  