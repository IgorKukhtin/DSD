--select * from gpSelect_MI_WeighingPartner_diff(inMovementId := 29882177 , inIsErased := 'False' ,  inSession := '9457') AS tt
--where tt.Price_diff = 0 OR tt.Amount_diff = 0

-- Function: gpGet_Movement_WeighingPartner_diff (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_WeighingPartner_diff (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_WeighingPartner_diff(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , FromId Integer, FromName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , UserId Integer, UserName TVarChar
             , isDocPartner Boolean
             , isDiff Boolean
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId_find_min Integer;
   DECLARE vbMovementId_find_max Integer;
   DECLARE vbContractId Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbisDiff Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���� �� �������� ����������
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
     THEN
         -- ��������� �� ���������
         vbOperDate        := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
         vbInvNumberPartner:= (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner());
         vbContractId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract());
         vbPaidKindId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PaidKind());

         -- ������ - ����� �������� ����������
         SELECT MIN (Movement.Id), MAX (Movement.Id)
                INTO vbMovementId_find_min, vbMovementId_find_max
         FROM Movement
              -- ���� ����� ��-��
              INNER JOIN MovementBoolean AS MovementBoolean_DocPartner
                                         ON MovementBoolean_DocPartner.MovementId = Movement.Id
                                        AND MovementBoolean_DocPartner.DescId     = zc_MovementBoolean_DocPartner()
              INNER JOIN MovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId     = zc_MovementString_InvNumberPartner()
                                       --  � ����� ������� ����������
                                       AND MovementString_InvNumberPartner.ValueData = vbInvNumberPartner
              INNER JOIN MovementLinkObject AS MLO_Contract
                                            ON MLO_Contract.MovementId = Movement.Id
                                           AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                           --  � ����� ���������
                                           AND MLO_Contract.ObjectId   = vbContractId
         WHERE Movement.OperDate BETWEEN vbOperDate - INTERVAL '1 DAY' AND vbOperDate
           AND Movement.DescId   = zc_Movement_WeighingPartner()
           AND Movement.StatusId = zc_Enum_Status_Complete()
        ;

         -- ��������
         IF vbMovementId_find_min <> vbMovementId_find_max
         THEN
             RAISE EXCEPTION '������.������� ��������� ���������� ����������.';
         END IF;

         -- ��������
         IF COALESCE (vbMovementId_find_min, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ���������� �� ������.';
         END IF;

         -- ������ - ����� �������� ����������
         inMovementId:= vbMovementId_find_min;

     END IF;

     -- ���������� ��� ������ ���� ����� � ������� ����������
     IF EXISTS (SELECT 1
                FROM gpSelect_MI_WeighingPartner_diff(inMovementId, 'False' ,  inSession := inSession) AS tmp
                WHERE COALESCE (tmp.Price_diff,0) <> 0 OR COALESCE (tmp.Amount_diff,0) <> 0)
     THEN
         vbisDiff := TRUE;
     ELSE
         vbisDiff := FALSE;
     END IF;


     RETURN QUERY
        WITH tmpStatus AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_Status())
        SELECT gpGet.Id, gpGet.InvNumber
             --, ('� ' || gpGet.InvNumberPartner || ' �� ' || zfConvert_DateToString (gpGet.OperDatePartner)) :: TVarChar AS InvNumberPartner
             , gpGet.InvNumberPartner
             , gpGet.OperDate, gpGet.OperDatePartner

             , tmpStatus.ObjectCode AS StatusCode
             , tmpStatus.ValueData  AS StatusName

             , gpGet.MovementId_parent, gpGet.OperDate_parent, gpGet.InvNumber_parent
             , gpGet.StartWeighing, gpGet.EndWeighing
             , gpGet.MovementId_Order, gpGet.InvNumberOrder
             , gpGet.FromId, gpGet.FromName
             , gpGet.PaidKindId, gpGet.PaidKindName
             , gpGet.ContractId, gpGet.ContractName, gpGet.ContractTagName
             , gpGet.UserId, gpGet.UserName
             , gpGet.isDocPartner
             , vbisDiff ::Boolean AS isDiff
             , gpGet.Comment
        FROM gpGet_Movement_WeighingPartner (inMovementId:= inMovementId, inSession:= inSession
                                            ) AS gpGet
             LEFT JOIN tmpStatus ON tmpStatus.Id = CASE WHEN gpGet.StatusId = zc_Enum_Status_Erased() THEN zc_Enum_Status_Erased()
                                                        WHEN gpGet.isDocPartner_real = TRUE THEN zc_Enum_Status_Complete()
                                                        ELSE zc_Enum_Status_UnComplete()
                                                   END
                                                  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.11.24                                        * all
*/

-- ����
--
-- SELECT * FROM gpGet_Movement_WeighingPartner_diff (inMovementId:= 30105796, inSession:= zfCalc_UserAdmin())
