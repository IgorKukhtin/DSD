-- Function: gpSelect_Object_Hardware()

DROP FUNCTION IF EXISTS gpSelect_Object_Hardware(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Hardware(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isCashRegister boolean
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , BaseBoardProduct TVarChar, ProcessorName TVarChar, DiskDriveModel TVarChar, PhysicalMemory TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Hardware()());

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
                     FROM tmpUnitAll),

         tmpCashRegister AS (SELECT
                                    Object_CashRegister.Id                 AS Id
                                  , Object_CashRegister.ObjectCode         AS Code
                                  , Object_CashRegister.ValueData          AS Name

                                  , ObjectString_SerialNumber.ValueData    AS SerialNumber

                                  , Object_Unit.Id                         AS UnitId
                                  , Object_Unit.ObjectCode                 AS UnitCode
                                  , Object_Unit.ValueData                  AS UnitName
                                  , ObjectString_TaxRate.ValueData         AS TaxRate

                                  , ObjectString_ComputerName.ValueData                       AS ComputerName
                                  , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
                                  , ObjectString_ProcessorName.ValueData                      AS ProcessorName
                                  , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
                                  , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

                                  , Object_CashRegister.isErased           AS isErased

                             FROM Object AS Object_CashRegister

                                  LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                                         ON ObjectString_SerialNumber.ObjectId = Object_CashRegister.Id
                                                        AND ObjectString_SerialNumber.DescId = zc_ObjectString_CashRegister_SerialNumber()

                                  LEFT JOIN ObjectString AS ObjectString_TaxRate
                                                         ON ObjectString_TaxRate.ObjectId = Object_CashRegister.Id
                                                        AND ObjectString_TaxRate.DescId = zc_ObjectString_CashRegister_TaxRate()

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

                             WHERE Object_CashRegister.DescId = zc_Object_CashRegister()
                               AND ObjectString_BaseBoardProduct.ValueData  <> '')

   SELECT
          Object_Hardware.Id                 AS Id
        , Object_Hardware.ObjectCode         AS Code
        , Object_Hardware.ValueData          AS Name

        , False                              AS isCashRegister

        , Object_Unit.Id                     AS UnitId
        , Object_Unit.ObjectCode             AS UnitCode
        , Object_Unit.ValueData              AS UnitName

        , ObjectString_BaseBoardProduct.ValueData                   AS BaseBoardProduct
        , ObjectString_ProcessorName.ValueData                      AS ProcessorName
        , ObjectString_DiskDriveModel.ValueData                     AS DiskDriveModel
        , ObjectString_PhysicalMemory.ValueData                     AS PhysicalMemory

        , Object_Hardware.isErased           AS isErased

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

   WHERE Object_Hardware.DescId = zc_Object_Hardware()
   UNION ALL
   SELECT
          tmpCashRegister.Id                 AS Id
        , tmpCashRegister.Code               AS Code
        , tmpCashRegister.ComputerName       AS Name

        , True                               AS isCashRegister

        , tmpCashRegister.UnitId             AS UnitId
        , tmpCashRegister.UnitCode           AS UnitCode
        , tmpCashRegister.UnitName           AS UnitName

        , tmpCashRegister.BaseBoardProduct   AS BaseBoardProduct
        , tmpCashRegister.ProcessorName      AS ProcessorName
        , tmpCashRegister.DiskDriveModel     AS DiskDriveModel
        , tmpCashRegister.PhysicalMemory     AS PhysicalMemory

        , tmpCashRegister.isErased           AS isErased
   FROM tmpCashRegister;

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Hardware(TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.   Шаблий О.В.
 12.04.20                                                                      *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Hardware('3')