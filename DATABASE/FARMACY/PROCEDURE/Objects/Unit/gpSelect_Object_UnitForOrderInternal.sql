-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForOrderInternal(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_UnitForOrderInternal(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForOrderInternal(
    IN inSelectAll   Boolean,       -- �������� ��� �������������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (NeedReorder Boolean, UnitId Integer, UnitCode Integer, UnitName TVarChar, ExistsOrderInternal Boolean, MovementId Integer) 
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);
    -- ������������ <�������� ����>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    vbOperDate := CURRENT_Date;

    RETURN QUERY 
    WITH 
         tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                       FROM ObjectLink AS ObjectLink_Unit_Juridical
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                       WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

        , OrderInternal AS (
                            SELECT 
                                MovementLinkObject_Unit.ObjectId AS UnitId
                               ,MAX(Movement.Id)::Integer        AS MovementId
                            FROM Movement
                                JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                            WHERE Movement.StatusId = zc_Enum_Status_UnComplete() 
                              AND Movement.DescId = zc_Movement_OrderInternal() 
                              AND Movement.OperDate = vbOperDate 
                            GROUP BY MovementLinkObject_Unit.ObjectId
                          ) 

    SELECT inSelectAll                           as NeedReorder
         , Object_Unit.Id                        as UnitId
         , Object_Unit.ObjectCode                as UnitCode 
         , Object_Unit.ValueData                 as UnitName
         , CASE 
             WHEN OrderInternal.UnitId is null 
               then False 
             ELSE TRUE 
           END::Boolean                              as ExistsOrderInternal
         , OrderInternal.MovementId
    FROM tmpUnit
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = tmpUnit.Unitid
        LEFT OUTER JOIN OrderInternal ON OrderInternal.UnitId = tmpUnit.Unitid
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.Unitid
    WHERE Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitUnitId() ;         
            
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitForOrderInternal(Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�
 05.05.16         *
 04.08.15                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_UnitForReprice ('2')