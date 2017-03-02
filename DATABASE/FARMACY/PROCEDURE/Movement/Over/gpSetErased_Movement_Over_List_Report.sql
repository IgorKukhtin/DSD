-- Function: gpSetErased_Movement_Over_List_Report (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Over_List_Report (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Over_List_Report(
    IN inUnitId              Integer   , -- �� ���� ����������� �� ���������
    IN inOperDate            TDateTime , -- ����
    IN inSession             TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;    
   DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Over());
    vbUserId := inSession;
    
    -- !!!������ ��� - ������������ <�������� ����>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical() 
                 );
                  
    -- ���������� ������������� �� ������� ������ ��������� ������������� (���� ������� ����)            
    CREATE TEMP TABLE tmpUnit_list (UnitId Integer) ON COMMIT DROP;    
     INSERT INTO tmpUnit_list (UnitId)
       SELECT ObjectBoolean_Over.ObjectId  AS UnitId
       FROM ObjectBoolean AS ObjectBoolean_Over
           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Over.ObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
       WHERE ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
         AND ObjectBoolean_Over.ValueData = TRUE      
         AND ObjectBoolean_Over.ObjectId <> inUnitId;
         
     -- ������� �������� ���� ������
     PERFORM lpSetErased_Movement (inMovementId := Movement.Id
                                 , inUserId     := vbUserId)
     FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        INNER JOIN tmpUnit_list ON tmpUnit_list.UnitId = MovementLinkObject_Unit.ObjectId
      WHERE Movement.DescId = zc_Movement_Over() 
        AND Movement.OperDate = inOperDate
        AND Movement.StatusId <> zc_Enum_Status_Erased(); 
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 01.03.17         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Over_List_Report (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
