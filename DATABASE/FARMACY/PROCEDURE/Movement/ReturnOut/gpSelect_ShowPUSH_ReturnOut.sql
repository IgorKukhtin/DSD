-- Function: gpSelect_ShowPUSH_ReturnOut(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_ReturnOut(integer,integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_ReturnOut(
    IN inMovementID        integer,          -- �������
    IN inParentID          integer,          -- ������
   OUT outShowMessage      Boolean,          -- ��������� ���������
   OUT outPUSHType         Integer,          -- ��� ���������
   OUT outText             Text,             -- ����� ���������
   OUT outSpecialLighting  Boolean ,      -- 
   OUT outTextColor        Integer ,      -- 
   OUT outColor            Integer ,      -- 
   OUT outBold             Boolean ,      -- 
    IN inSession           TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
BEGIN

    outShowMessage := False;
    outSpecialLighting  := True;
    outTextColor        := zc_Color_Red();
    outColor            := zc_Color_White();
    outBold             := True;

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_ReturnOut
              WHERE Movement_ReturnOut.Id <> COALESCE(inMovementID, 0)
                AND Movement_ReturnOut.ParentId = inParentId
                AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
                AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut())
    THEN

       SELECT string_agg('����� '||Movement_ReturnOut.InvNumber||' ���� '||TO_CHAR (Movement_ReturnOut.OperDate, 'dd.mm.yyyy'), CHR(13) ORDER BY Movement_ReturnOut.OperDate)
       INTO vbText
       FROM Movement AS Movement_ReturnOut
       WHERE Movement_ReturnOut.Id <> COALESCE(inMovementID, 0)
         AND Movement_ReturnOut.ParentId = inParentId
         AND Movement_ReturnOut.StatusId <> zc_Enum_Status_Erased()
         AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut();

      outShowMessage := True;
      outPUSHType := 3;
      outText := '�� ������� '||(SELECT Movement.InvNumber FROM Movement WHERE Movement.ID = inParentID)||
                 ' ������� ��������:'||CHR(13)||COALESCE(vbText, '');
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.11.19                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_ReturnOut(16616042 , 15680114, '3')