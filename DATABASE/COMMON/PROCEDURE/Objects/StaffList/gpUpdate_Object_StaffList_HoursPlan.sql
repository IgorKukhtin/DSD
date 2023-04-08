-- Function: gpUpdate_Object_StaffList_HoursPlan(

DROP FUNCTION IF EXISTS gpUpdate_Object_StaffList_HoursPlan (Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_StaffList_HoursPlan(
    IN inUnitId              Integer,       -- Подразделение
    IN inHoursPlan           TFloat    , -- Общий план часов за месяц на человека
    IN inHoursPlan_new       TFloat    , -- новое значение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_StaffList());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_StaffList())
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_StaffList())
                       ;
   END IF;

  IF inUnitId <> 0 
  THEN 
      INSERT INTO _tmpUnit(UnitId)
                 SELECT inUnitId;
  ELSE 
      INSERT INTO _tmpUnit (UnitId)
                 SELECT OBJECT.Id FROM OBJECT
                 WHERE OBJECT.DescId = zc_Object_Unit();
  END IF;


   -- пересохранили свойство <Общий план часов за месяц на человека>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StaffList_HoursPlan(), Object_StaffList.Id, inHoursPlan_new)
         , lpInsert_ObjectProtocol (Object_StaffList.Id, vbUserId)
   FROM _tmpUnit
          LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                               ON ObjectLink_StaffList_Unit.ChildObjectId = _tmpUnit.UnitId
                              AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
                                
          LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = ObjectLink_StaffList_Unit.ObjectId
          
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                                ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()

   WHERE Object_StaffList.DescId = zc_Object_StaffList()
     AND Object_StaffList.isErased = False
     AND COALESCE (ObjectFloat_HoursPlan.ValueData,0) = inHoursPlan;
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.04.23         * 
*/

-- тест
--