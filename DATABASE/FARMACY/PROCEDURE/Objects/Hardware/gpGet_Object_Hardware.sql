-- Function: gpGet_Object_Hardware()

DROP FUNCTION IF EXISTS gpGet_Object_Hardware(integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Hardware(
    IN inId            Integer,       -- ключ объекта <Города>
    IN isCashRegister  Boolean,       -- касса
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , BaseBoardProduct TVarChar, ProcessorName TVarChar, DiskDriveModel TVarChar, PhysicalMemory TVarChar
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   
   IF isCashRegister = True
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение данных по кассам запрещено...';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_Hardware()) AS Code
           , CAST ('' as TVarChar)     AS Name

           , CAST (0 as Integer)       AS UnitId
           , CAST ('' as TVarChar)     AS UnitName

           , CAST ('' as TVarChar)     AS BaseBoardProduct
           , CAST ('' as TVarChar)     AS ProcessorName
           , CAST ('' as TVarChar)     AS DiskDriveModel
           , CAST ('' as TVarChar)     AS PhysicalMemory;

   ELSE
       RETURN QUERY
       SELECT
             Object_Hardware.Id         AS Id
           , Object_Hardware.ObjectCode AS Code
           , Object_Hardware.ValueData  AS Name

           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName

           , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
           , ObjectString_ProcessorName.ValueData                      AS ProcessorName
           , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
           , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

       FROM Object AS Object_Hardware
            LEFT JOIN ObjectLink AS ObjectLink_Hardware_Unit
                                 ON ObjectLink_Hardware_Unit.ObjectId = Object_Hardware.Id
                                AND ObjectLink_Hardware_Unit.DescId = zc_ObjectLink_Hardware_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Hardware_Unit.ChildObjectId
            
            LEFT JOIN ObjectString AS ObjectString_BaseBoardProduct 
                                   ON ObjectString_BaseBoardProduct.ObjectId = Object_Hardware.Id
                                  AND ObjectString_BaseBoardProduct.DescId = zc_ObjectString_Hardware_BaseBoardProduct()
            LEFT JOIN ObjectString AS ObjectString_ProcessorName 
                                   ON ObjectString_ProcessorName.ObjectId = Object_Hardware.Id
                                  AND ObjectString_ProcessorName.DescId = zc_ObjectString_Hardware_ProcessorName()
            LEFT JOIN ObjectString AS ObjectString_DiskDriveModel 
                                   ON ObjectString_DiskDriveModel.ObjectId = Object_Hardware.Id
                                  AND ObjectString_DiskDriveModel.DescId = zc_ObjectString_Hardware_DiskDriveModel()

            LEFT JOIN ObjectString AS ObjectString_PhysicalMemory
                                  ON ObjectString_PhysicalMemory.ObjectId = Object_Hardware.Id
                                 AND ObjectString_PhysicalMemory.DescId = zc_ObjectString_Hardware_PhysicalMemory()
       WHERE Object_Hardware.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Hardware(integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 12.04.20                                                                      *  
*/

-- тест
-- SELECT * FROM gpGet_Object_Hardware (0, True, '3')