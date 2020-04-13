-- Function: gpSelect_Object_CashRegister()

DROP FUNCTION IF EXISTS gpSelect_Object_CashRegister(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CashRegister(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CashRegisterKindId Integer, CashRegisterKindName TVarChar
             , SerialNumber TVarChar
             , TimePUSHFinal1 TDateTime, TimePUSHFinal2 TDateTime
             , UnitName TVarChar, TaxRate TVarChar
             , GetHardwareData Boolean, ComputerName TVarChar, BaseBoardProduct TVarChar, ProcessorName TVarChar, DiskDriveModel TVarChar, PhysicalMemory TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CashRegister()());

   RETURN QUERY
   WITH tmpUnitAll AS (SELECT
                              MovementLinkObject_Unit.ObjectId           AS UnitID,
                              MovementLinkObject_CashRegister.ObjectId   AS CashRegisterID,
                              MAX(Movement.OperDate)                     AS OperDate
                       FROM Movement

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                            INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                          ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                   
                      WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '10 day'
                        AND Movement.OperDate <=  CURRENT_DATE
                        AND Movement.DescId = zc_Movement_Check()
                      GROUP BY MovementLinkObject_Unit.ObjectId, MovementLinkObject_CashRegister.ObjectId),
                      
         tmpUnit AS (SELECT 
                            ROW_NUMBER() OVER (PARTITION BY tmpUnitAll.UnitID, tmpUnitAll,CashRegisterID ORDER BY tmpUnitAll.OperDate DESC) AS Ord,
                            tmpUnitAll.UnitID,
                            tmpUnitAll.CashRegisterID 
                     FROM tmpUnitAll)
   
   SELECT
          Object_CashRegister.Id                 AS Id
        , Object_CashRegister.ObjectCode         AS Code
        , Object_CashRegister.ValueData          AS Name

        , Object_CashRegisterKind.Id             AS CashRegisterKindId
        , Object_CashRegisterKind.ValueData      AS CashRegisterKindName
        
        , ObjectString_SerialNumber.ValueData    AS SerialNumber
        , COALESCE (ObjectDate_TimePUSHFinal1.ValueData, ('01.01.2019 21:00')::TDateTime) AS TimePUSHFinal1
        , ObjectDate_TimePUSHFinal2.ValueData    AS TimePUSHFinal2
        
        , Object_Unit.ValueData                  AS UnitName
        , ObjectString_TaxRate.ValueData         AS TaxRate
        
        , COALESCE(ObjectBoolean_GetHardwareData.ValueData, False)  AS GetHardwareData
        , ObjectString_ComputerName.ValueData                       AS ComputerName
        , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
        , ObjectString_ProcessorName.ValueData                      AS ProcessorName
        , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
        , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

        , Object_CashRegister.isErased           AS isErased

   FROM Object AS Object_CashRegister
        LEFT JOIN ObjectLink AS ObjectLink_CashRegister_CashRegisterKind
                             ON ObjectLink_CashRegister_CashRegisterKind.ObjectId = Object_CashRegister.Id
                            AND ObjectLink_CashRegister_CashRegisterKind.DescId = zc_ObjectLink_CashRegister_CashRegisterKind()
        LEFT JOIN Object AS Object_CashRegisterKind ON Object_CashRegisterKind.Id = ObjectLink_CashRegister_CashRegisterKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_SerialNumber 
                               ON ObjectString_SerialNumber.ObjectId = Object_CashRegister.Id
                              AND ObjectString_SerialNumber.DescId = zc_ObjectString_CashRegister_SerialNumber()
          
        LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal1 
                              ON ObjectDate_TimePUSHFinal1.ObjectId = Object_CashRegister.Id
                             AND ObjectDate_TimePUSHFinal1.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal1()

        LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal2 
                              ON ObjectDate_TimePUSHFinal2.ObjectId = Object_CashRegister.Id
                             AND ObjectDate_TimePUSHFinal2.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal2()
                             
        LEFT JOIN ObjectString AS ObjectString_TaxRate 
                               ON ObjectString_TaxRate.ObjectId = Object_CashRegister.Id
                              AND ObjectString_TaxRate.DescId = zc_ObjectString_CashRegister_TaxRate()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_GetHardwareData 
                                ON ObjectBoolean_GetHardwareData.ObjectId = Object_CashRegister.Id
                               AND ObjectBoolean_GetHardwareData.DescId = zc_ObjectBoolean_CashRegister_GetHardwareData()

        LEFT JOIN ObjectString AS ObjectString_ComputerName
                               ON ObjectString_ComputerName.ObjectId = Object_CashRegister.Id
                              AND ObjectString_ComputerName.DescId = zc_ObjectString_CashRegister_ComputerName()
        LEFT JOIN ObjectString AS ObjectString_BaseBoardProduct 
                               ON ObjectString_BaseBoardProduct.ObjectId = Object_CashRegister.Id
                              AND ObjectString_BaseBoardProduct.DescId = zc_ObjectString_CashRegister_BaseBoardProduct()
        LEFT JOIN ObjectString AS ObjectString_ProcessorName 
                               ON ObjectString_ProcessorName.ObjectId = Object_CashRegister.Id
                              AND ObjectString_ProcessorName.DescId = zc_ObjectString_CashRegister_ProcessorName()
        LEFT JOIN ObjectString AS ObjectString_DiskDriveModel 
                               ON ObjectString_DiskDriveModel.ObjectId = Object_CashRegister.Id
                              AND ObjectString_DiskDriveModel.DescId = zc_ObjectString_CashRegister_DiskDriveModel()

        LEFT JOIN ObjectString AS ObjectString_PhysicalMemory
                              ON ObjectString_PhysicalMemory.ObjectId = Object_CashRegister.Id
                             AND ObjectString_PhysicalMemory.DescId = zc_ObjectString_CashRegister_PhysicalMemory()

        LEFT JOIN tmpUnit ON tmpUnit.Ord = 1 AND  tmpUnit.CashRegisterID = Object_CashRegister.Id 
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitID

   WHERE Object_CashRegister.DescId = zc_Object_CashRegister();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CashRegister(TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.   Шаблий О.В.
 08.04.20                                                                      *  
 04.03.19                                                                      *  
 22.05.15                         *  
*/

-- тест
-- SELECT * FROM gpSelect_Object_CashRegister('3')