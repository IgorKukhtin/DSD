-- Function: gpGet_Movement_TransportGoods_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_TransportGoods_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_TransportGoods_ReportName (
    IN inMovementId         Integer  , -- ���� ���������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
   DECLARE vbPlaceOf TVarChar;
   DECLARE vbLength TFloat;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TransportGoods());

     -- ���� ��������� zc_objectString_Branch_PlaceOf + �������  ��� + ���� � ���� ��������� zc_ObjectFloat_Car_Length - ����� ����� ����� ����� 06,10,2021
     -- ���� <= 06.10.2021 ����� ������ �������� ������ �������
     vbPlaceOf := (SELECT CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                               ELSE '' -- '�.��i���'
                          END  :: TVarChar   AS PlaceOf
                   FROM MovementLinkObject AS MovementLinkObject_From
                       LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                            ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                           AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                       LEFT JOIN ObjectString AS ObjectString_PlaceOf                           
                                              ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                             AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
                   WHERE MovementLinkObject_From.MovementId = inMovementId
                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                   )::TVarChar;

     vbLength := (SELECT ObjectFloat_Length.ValueData
                  FROM (SELECT MovementLinkMovement.MovementChildId
                        FROM MovementLinkMovement
                        WHERE MovementLinkMovement.MovementId = inMovementId
                          AND MovementLinkMovement.DescId = zc_MovementLinkMovement_TransportGoods()
                       ) AS tmp
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                   ON MovementLinkObject_Car.MovementId = tmp.MovementChildId
                                                  AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                      INNER JOIN ObjectFloat AS ObjectFloat_Length
                                             ON ObjectFloat_Length.ObjectId = MovementLinkObject_Car.ObjectId
                                            AND ObjectFloat_Length.DescId = zc_ObjectFloat_Car_Length()
                  );


     --���������
       SELECT CASE WHEN 1=1 /*COALESCE (vbPlaceOf,'') <> '' AND COALESCE (vbLength,0) <> 0*/
                   THEN COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TTN')
                   ELSE 'PrintMovement_TTN'
              END :: TVarChar
              INTO vbPrintFormName
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
            LEFT JOIN PrintForms_View
                   ON COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.JuridicalId = 0
                  AND PrintForms_View.ReportType = 'TransportGoods'
                  AND PrintForms_View.DescId = zc_Movement_TransportGoods()
       WHERE Movement.Id = inMovementId
       ;

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.21         *
*/

-- ����
--SELECT gpGet_Movement_TransportGoods_ReportName FROM gpGet_Movement_TransportGoods_ReportName(inMovementId := 21045471,  inSession := '5'); -- ���