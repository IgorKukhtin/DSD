-- Function: gpGet_Movement_MobilebyOrderClient()

DROP FUNCTION IF EXISTS gpGet_Movement_MobilebyOrderClient ( TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MobilebyOrderClient(
    IN inBarCode           TVarChar   , --
    IN inInvNumber         TVarChar   , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id                 Integer
             , InvNumber          TVarChar
             , InvNumberFull      TVarChar
               )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     IF SUBSTRING(inBarCode, 1, 4) = zc_BarCodePref_Movement()
     THEN

       SELECT Movement.Id, Movement.StatusId, Movement.InvNumber
       INTO vbId, vbStatusId, vbInvNumber
       FROM Movement
       WHERE Movement.DescId  = zc_Movement_OrderClient()
         AND Movement.Id = SUBSTRING(inBarCode, 5, 8)::Integer;     

     ELSEIF COALESCE(inBarCode, '') = '' AND COALESCE(inInvNumber, '') <> ''
     THEN

       SELECT Movement.Id, Movement.StatusId, Movement.InvNumber
       INTO vbId, vbStatusId, vbInvNumber
       FROM Movement
       WHERE Movement.DescId  = zc_Movement_OrderClient()
         AND Movement.InvNumber = TRIM(inInvNumber);     

     ELSE
       vbId := 0;
     END IF;
     
     IF COALESCE (vbId, 0) = 0
     THEN
       IF COALESCE(inBarCode, '') = ''
       THEN
         RAISE EXCEPTION '������. ����� ������� c ������� <%> �� �����.', inInvNumber;
       ELSE
         RAISE EXCEPTION '������. ����� ������� �� �/� <%> �� �����.', inBarCode;       
       END IF;
     ELSEIF vbStatusId = zc_Enum_Status_Erased()  
     THEN
       RAISE EXCEPTION '������. ����� ������� ����� <%> ������.', vbInvNumber;
     END IF;

     -- ���������
     RETURN QUERY
       SELECT Movement.Id            AS Id
            , Movement.InvNumber     AS InvNumber
            , Movement.InvNumber     AS InvNumberFull
            
       FROM Movement
       WHERE Movement.Id = vbId
      ;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.04.24                                                       *
*/

-- ����
-- 

select * from gpGet_Movement_MobilebyOrderClient(inBarCode := '223000000908' , inInvNumber := '' ,  inSession := '5');
