 -- Function: gpInsertUpdate_Object_SubjectDoc_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SubjectDoc_Load (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SubjectDoc_Load(
    IN inSubjectDocName   TVarChar   ,
    IN inShort            TVarChar  , -- 
    IN inReasonName       TVarChar  ,
    IN inMovementDesc     TVarChar ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReasonId Integer;
   DECLARE vbSubjectDocId Integer;
   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementDesc TVarChar;
   DECLARE vbText1 TVarChar;
   DECLARE vbText2 TVarChar;
   DECLARE vbReasonCode Integer;
   DECLARE vbSubjectDocCode Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());

     --��������
     IF COALESCE (inSubjectDocName,'') = ''
     THEN
         RETURN;
     END IF;

     --��������
     --RAISE EXCEPTION '������. .'; 

     -- ������� ����������
     SELECT Object.Id
          , Object.ObjectCode
    INTO vbSubjectDocId, vbSubjectDocCode 
     FROM Object
     WHERE Object.DescId = zc_Object_SubjectDoc()
       AND UPPER (TRIM (ObjectString.ValueData)) = UPPER (TRIM (inSubjectDocName)) 
       AND Object.ObjectCode > 1000
     LIMIT 1;

     IF COALESCE (inReasonName,'') <> ''
     THEN
         SELECT Object.Id
              , Object.ObjectCode
       INTO vbReasonId, vbReasonCode 
         FROM Object
         WHERE Object.DescId = zc_Object_Reason()
           AND UPPER (TRIM (ObjectString.ValueData)) = UPPER (TRIM (inReasonName)) 
           AND Object.ObjectCode >1000
         LIMIT 1 ;

         IF COALESCE (vbReasonId,0) = 0
         THEN 
              vbReasonCode := lfGet_ObjectCode(0, zc_Object_Reason());
              vbReasonId := gpInsertUpdate_Object_Reason(ioId	             := 0     ::Integer
                                                       , inCode              := CASE WHEN vbReasonCode < 1001 THEN vbReasonCode + 1000 ELSE vbReasonCode END ::Integer
                                                       , inName              := TRIM (inReasonName) ::TVarChar
                                                       , inShort             := ''    ::TVarChar
                                                       , inReturnKindId      := NULL  ::Integer
                                                       , inReturnDescKindId  := NULL  ::Integer
                                                       , inPeriodDays        := NULL  ::TFloat
                                                       , inPeriodTax         := NULL  ::TFloat
                                                       , inisReturnIn        := FALSE :: Boolean
                                                       , inisSendOnPrice     := FALSE :: Boolean
                                                       , inComment           := ''    ::TVarChar
                                                       , inSession           := inSession::TVarChar 
                                                        );
         END IF;
     END IF;
     --
    
     --
     vbSubjectDocCode := lfGet_ObjectCode (vbSubjectDocCode, zc_Object_SubjectDoc());

     PERFORM gpInsertUpdate_Object_SubjectDoc(ioId           := COALESCE (vbSubjectDocId,0) ::Integer 
                                            , inCode         := CASE WHEN vbSubjectDocCode < 1001 THEN vbSubjectDocCode + 1000 ELSE vbSubjectDocCode END ::Integer
                                            , inName         := TRIM (inSubjectDocName)     :: TVarChar
                                            , inShort        := TRIM (inShort)              :: TVarChar
                                            , inReasonId     := vbReasonId                  :: Integer
                                            , inMovementDesc := NULL                        :: TVarChar   
                                            , inComment      := TRIM (inMovementDesc)       :: TVarChar  
                                            , inSession      := inSession                   :: TVarChar
                                            );
   
   END IF;
   
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION '����. ��. <%>', inSubjectDocName; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.11.23         *
*/

-- ����
--
SELECT * FROM gpInsertUpdate_Object_SubjectDoc_Load(
     inSubjectDocName := '���������� ��� - ����������':: TVarChar   ,
     inShort          := '��-����������� �������'::TVarChar  , -- 
     inReasonName     := '���. ����� (������)' ::TVarChar  ,
     inMovementDesc   := '������� �� ���������� / ����������� �� ����' ::TVarChar ,
     inSession        := '9457'::TVarChar 
     )
