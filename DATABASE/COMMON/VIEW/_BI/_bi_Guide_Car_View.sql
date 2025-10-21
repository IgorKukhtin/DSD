-- View: _bi_Guide_Car_View

 DROP VIEW IF EXISTS _bi_Guide_Car_View;

-- Справочник Авто
/*
-- Названия
Id
Code
Name
Name_all
-- Признак "Удален да/нет"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_Car_View
AS
      SELECT Object_Car.Id                AS Id
           , Object_Car.ObjectCode        AS Code
           , Object_Car.ValueData         AS Name
           , (Object_Car.ValueData || COALESCE (' ' || Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '')) ::TVarChar AS Name_all
             -- Признак "Удален да/нет"
           , Object_Car.isErased

           , Object_CarModel.ValueData     AS CarModelName 
           , Object_CarType.ValueData      AS CarTypeName
           , Object_BodyType.ValueData     AS BodyTypeName
           , Object_CarProperty.ValueData  AS CarPropertyName

           , Object_Unit.ValueData           AS UnitName
           , Object_PersonalDriver.ValueData AS PersonalDriverName
           , Object_Unit_Driver.ValueData    AS UnitName_Driver

       FROM Object AS Object_Car
            LEFT JOIN ObjectLink AS Car_CarModel
                                 ON Car_CarModel.ObjectId = Object_Car.Id
                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS Car_CarType
                                 ON Car_CarType.ObjectId = Object_Car.Id
                                AND Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = Car_CarType.ChildObjectId

            LEFT JOIN ObjectLink AS Car_BodyType
                                 ON Car_BodyType.ObjectId = Object_Car.Id
                                AND Car_BodyType.DescId = zc_ObjectLink_Car_BodyType()
            LEFT JOIN Object AS Object_BodyType ON Object_BodyType.Id = Car_BodyType.ChildObjectId

            LEFT JOIN ObjectLink AS Car_CarProperty
                                 ON Car_CarProperty.ObjectId = Object_Car.Id
                                AND Car_CarProperty.DescId = zc_ObjectLink_Car_CarProperty()
            LEFT JOIN Object AS Object_CarProperty ON Object_CarProperty.Id = Car_CarProperty.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                 ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver 
                                 ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Object_PersonalDriver.Id
                                AND ObjectLink_Personal_Unit.descId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit_Driver ON Object_Unit_Driver.Id = ObjectLink_Personal_Unit.ChildObjectId

       WHERE Object_Car.DescId = zc_Object_Car()
      ;

ALTER TABLE _bi_Guide_Car_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_Car_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_Car_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Car_View ORDER BY 1 LIMIT 100
