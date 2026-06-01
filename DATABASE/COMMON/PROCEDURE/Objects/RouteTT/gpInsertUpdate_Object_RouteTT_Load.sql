-- Function: gpInsertUpdate_Object_RouteTT_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RouteTT_Load (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RouteTT_Load(
    IN inUnitName           TVarChar  ,
    IN inRouteTTName        TVarChar  ,
    IN inPersonalName       TVarChar  ,
    IN inPositionName       TVarChar  ,
    IN inPersonalGroupName  TVarChar  ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId          Integer;
           vbUnitId          Integer;
           vbPersonalId      Integer;
           vbPositionId      Integer;
           vbPersonalGroupId Integer;
           vbRouteTTId       Integer;
           vbRouteTTCode     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());

     IF COALESCE (inRouteTTName,'') = ''
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inUnitName,'') = ''
     THEN
         RAISE EXCEPTION 'Помилка.Для маршрута <%> значення Підрозділ не заповнено', inRouteTTName;
     END IF;

     -- проверка
     IF COALESCE (inPositionName,'') = ''
     THEN
         RAISE EXCEPTION 'Помилка.Для маршрута <%> значення Посада не заповнено', inRouteTTName;
     END IF;
     
     -- проверка
     IF COALESCE (inPersonalGroupName,'') = ''
     THEN
         RAISE EXCEPTION 'Помилка.Для маршрута <%> значення Група співробітників не заповнено', inRouteTTName;
     END IF;

    
     -- находим Подразделение
     vbUnitId := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName) AND Object.DescId = zc_Object_Unit() Limit 1);
     
     IF COALESCE (vbUnitId,0) = 0
     THEN
         RAISE EXCEPTION 'Помилка. Підрозділ <%> не знайдено', inUnitName;
     END IF;

     -- находим Должность
     vbPositionId := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPositionName) AND Object.DescId = zc_Object_Position() Limit 1);
     
     IF COALESCE (vbPositionId,0) = 0
     THEN
         RAISE EXCEPTION 'Помилка. Посаду <%> не знайдено', inPositionName;
     END IF;

     -- находим Группу сотрудника
     vbPersonalGroupId := (SELECT Object.Id FROM Object WHERE TRIM (Object.ValueData) ILIKE TRIM (inPersonalGroupName) AND Object.DescId = zc_Object_PersonalGroup() Limit 1);
     
     IF COALESCE (vbPersonalGroupId,0) = 0
     THEN
         RAISE EXCEPTION 'Помилка. Групу співробітників <%> не знайдено', inPersonalGroupName;
     END IF;
     
     -- находим Сотрудника (не обязательный парамеор)
     vbPersonalId := (SELECT tmp.PersonalId
                      FROM
                          (SELECT Object_Personal.Id AS PersonalId
                                , ROW_NUMBER() OVER(PARTITION BY ObjectLink_Personal_Member.ChildObjectId 
                                                    ORDER BY COALESCE (ObjectBoolean_Main.ValueData, FALSE) ASC, Object_Personal.Id ASC) AS Ord
                           FROM Object AS Object_Personal
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                                                     AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                     ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                    AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                    
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                        ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                                       AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()                            
    
                          WHERE Object_Personal.DescId = zc_Object_Personal()
                            AND TRIM (Object_Personal.ValueData) ILIKE TRIM (inPersonalName)
                            AND Object_Personal.isErased = FALSE
                            AND ObjectLink_Personal_Position.ChildObjectId = vbPositionId
                           ) AS tmp
                      WHERE tmp.Ord = 1
                      );
     
     --находим маршрут ТТ
     SELECT Object.Id, Object.ObjectCode 
    INTO vbRouteTTId, vbRouteTTCode 
     FROM Object
     WHERE TRIM (Object.ValueData) ILIKE TRIM (inRouteTTName) AND Object.DescId = zc_Object_RouteTT()
     Limit 1;
     

     -- сохранили связь с <>
     PERFORM gpInsertUpdate_Object_RouteTT (ioId              := COALESCE (vbRouteTTId,0)    ::Integer
                                          , inCode            := COALESCE (vbRouteTTCOde,0)  ::Integer
                                          , inName            := inRouteTTName               ::TVarChar
                                          , inUnitId          := vbUnitId                    ::Integer
                                          , inPersonalId      := vbPersonalId                ::Integer
                                          , inPositionId      := vbPositionId                ::Integer
                                          , inPersonalGroupId := vbPersonalGroupId           ::Integer
                                          , inComment         := ''                          ::TVarChar
                                          , inSession         := inSession                   ::TVarChar
                                          );   
   
     if vbUserId = 9457 then  RAISE EXCEPTION 'Test admin.Ok'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.26         *
*/

-- тест
--