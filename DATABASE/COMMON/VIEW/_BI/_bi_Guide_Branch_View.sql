-- View: _bi_Guide_Branch_View

 DROP VIEW IF EXISTS _bi_Guide_Branch_View;

-- Справочник Филиалы
CREATE OR REPLACE VIEW _bi_Guide_Branch_View
AS
       SELECT
             Object_Branch.Id         AS Id
           , Object_Branch.ObjectCode AS Code
           , Object_Branch.ValueData  AS Name
           --Доступ просмотра
           , Object_Branch.AccessKeyId
           -- Признак "Удален да/нет"
           , Object_Branch.isErased   AS isErased
           --номер филиала в налоговой
           , ObjectString_InvNumber.ValueData  AS InvNumber
           --місто складання
           , ObjectString_PlaceOf.ValueData    AS PlaceOf
           --Сотрудник (бухгалтер)
           , Object_Personal.Id         AS PersonalId
           , Object_Personal.ValueData  AS PersonalName 
           --Сотрудник (комірник)
           , Object_PersonalStore.Id         AS PersonalStoreId
           , Object_PersonalStore.ValueData  AS PersonalStoreName
           --Сотрудник (бухгалтер)
           , Object_PersonalBookkeeper.Id         AS PersonalBookkeeperId
           , Object_PersonalBookkeeper.ValueData  AS PersonalBookkeeperName
           --Сотрудник (бухгалтер) подписант
           , ObjectString_PersonalBookkeeper.ValueData ::TVarChar AS PersonalBookkeeper_sign
           --Водитель
           , Object_PersonalDriver.Id         AS PersonalDriverId
           , Object_PersonalDriver.ValueData  AS PersonalDriverName 
           --Водитель/Экспедитор
           , Object_Member1.Id                AS Member1Id
           , Object_Member1.ValueData         AS Member1Name 
           --Бухгалтер
           , Object_Member2.Id                AS Member2Id
           , Object_Member2.ValueData         AS Member2Name 
           --Ответственное лицо(відпуск дозволив)
           , Object_Member3.Id                AS Member3Id
           , Object_Member3.ValueData         AS Member3Name 
           --Ответственное лицо(здав)
           , Object_Member4.Id                AS Member4Id
           , Object_Member4.ValueData         AS Member4Name 
           --Подразделения (основной склад)
           , Object_Unit.Id         AS UnitId
           , Object_Unit.ValueData  AS UnitName
           --Подразделения (склад возвратов)
           , Object_UnitReturn.Id         AS UnitReturnId
           , Object_UnitReturn.ValueData  AS UnitReturnName
           --загрузка налоговых из медка
           , COALESCE (ObjectBoolean_Medoc.ValueData, False)      AS IsMedoc
           --Партионный учет долгов нал
           , COALESCE (ObjectBoolean_PartionDoc.ValueData, False) AS IsPartionDoc

       FROM Object AS Object_Branch
        --номер филиала в налоговой
        LEFT JOIN ObjectString AS ObjectString_InvNumber
                               ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                              AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()       
        --місто складання
        LEFT JOIN ObjectString AS ObjectString_PlaceOf
                               ON ObjectString_PlaceOf.ObjectId = Object_Branch.Id
                              AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()       
        --Сотрудник (бухгалтер) подписант
        LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                               ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                              AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()   
        --загрузка налоговых из медка                      
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Medoc
                                ON ObjectBoolean_Medoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_Medoc.DescId = zc_ObjectBoolean_Branch_Medoc()    
        --Партионный учет долгов нал            
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                ON ObjectBoolean_PartionDoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc() 
        --Сотрудник (бухгалтер)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                             ON ObjectLink_Branch_Personal.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
        LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Branch_Personal.ChildObjectId     
        --Сотрудник (комірник)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                             ON ObjectLink_Branch_PersonalStore.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
        LEFT JOIN Object AS  Object_PersonalStore ON Object_PersonalStore.Id = ObjectLink_Branch_PersonalStore.ChildObjectId  
        --Сотрудник (бухгалтер)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                             ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
        LEFT JOIN Object AS Object_PersonalBookkeeper ON Object_PersonalBookkeeper.Id = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
        --Водитель
        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalDriver
                             ON ObjectLink_Branch_PersonalDriver.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalDriver.DescId = zc_ObjectLink_Branch_PersonalDriver()
        LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Branch_PersonalDriver.ChildObjectId
        -- 	Водитель/Экспедитор
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member1
                             ON ObjectLink_Branch_Member1.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member1.DescId = zc_ObjectLink_Branch_Member1()
        LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = ObjectLink_Branch_Member1.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member2
                             ON ObjectLink_Branch_Member2.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member2.DescId = zc_ObjectLink_Branch_Member2()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_Branch_Member2.ChildObjectId
        --Ответственное лицо(відпуск дозволив)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member3
                             ON ObjectLink_Branch_Member3.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member3.DescId = zc_ObjectLink_Branch_Member3()
        LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = ObjectLink_Branch_Member3.ChildObjectId
        --Ответственное лицо(здав)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member4
                             ON ObjectLink_Branch_Member4.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member4.DescId = zc_ObjectLink_Branch_Member4()
        LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = ObjectLink_Branch_Member4.ChildObjectId
        --Подразделения (основной склад)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Unit
                             ON ObjectLink_Branch_Unit.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Unit.DescId = zc_ObjectLink_Branch_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Branch_Unit.ChildObjectId
        --Подразделения (склад возвратов)
        LEFT JOIN ObjectLink AS ObjectLink_Branch_UnitReturn
                             ON ObjectLink_Branch_UnitReturn.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_UnitReturn.DescId = zc_ObjectLink_Branch_UnitReturn()
        LEFT JOIN Object AS Object_UnitReturn ON Object_UnitReturn.Id = ObjectLink_Branch_UnitReturn.ChildObjectId
 
       WHERE Object_Branch.DescId = zc_Object_Branch()
      ;

ALTER TABLE _bi_Guide_Branch_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.25         * all
 09.05.25                                        *
*/

-- тест
--  SELECT * FROM _bi_Guide_Branch_View  limit 10
