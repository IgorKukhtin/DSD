-- Function: gpSelect_Object_UnitForSAUA()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForSAUA (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForSAUA(
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, isChecked boolean, UnitName TVarChar, UnitCalculationId Integer)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    RETURN QUERY

        WITH tmpUnit AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId           AS UnitId
                         FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY')


        SELECT Object_Unit.Id          AS Id
             , False                   AS isChecked
             , (COALESCE (Object_Juridical.ValueData, '') ||'  **  '||
                COALESCE (Object_Unit.ValueData, '')) :: TVarChar AS Name
             , tmpUnit.UnitId
        FROM Object AS Object_Unit

             LEFT JOIN tmpUnit ON tmpUnit.UnitId = Object_Unit.Id

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

             LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                    ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                   AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND Object_Unit.isErased = False
          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) = 4
          AND COALESCE (ObjectString_Unit_Address.ValueData, '') <> ''
          AND Object_Unit.ValueData NOT ILIKE '%�����%'

        ORDER BY Object_Juridical.ValueData , Object_Unit.ValueData
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.11.20                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_UnitForSAUA (zfCalc_UserAdmin());