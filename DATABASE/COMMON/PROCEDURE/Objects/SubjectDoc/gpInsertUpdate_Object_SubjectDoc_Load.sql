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

     IF COALESCE (inReasonName,'') <> ''
     THEN
         SELECT Object.Id
              , Object.ObjectCode
       INTO vbReasonId, vbReasonCode 
         FROM Object
         WHERE Object.DescId = zc_Object_Reason()
           AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inReasonName)) 
           AND Object.ObjectCode >1000
         LIMIT 1 ;

         IF COALESCE (vbReasonId,0) = 0
         THEN 
              vbReasonCode := lfGet_ObjectCode(0, zc_Object_Reason());
              vbReasonId := gpInsertUpdate_Object_Reason(ioId	             := 0     ::Integer
                                                       , inCode              := CASE WHEN vbReasonCode < 1001 THEN 1001 ELSE vbReasonCode END ::Integer
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

     -- ������� ����������
     SELECT Object.Id
          , Object.ObjectCode
    INTO vbSubjectDocId, vbSubjectDocCode 
     FROM Object
          LEFT JOIN ObjectLink AS ObjectLink_Reason
                               ON ObjectLink_Reason.ObjectId = Object.Id 
                              AND ObjectLink_Reason.DescId = zc_ObjectLink_SubjectDoc_Reason()
     WHERE Object.DescId = zc_Object_SubjectDoc()
       AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inSubjectDocName)) 
       AND Object.ObjectCode > 1000 
       AND COALESCE (vbReasonId,0) = COALESCE (ObjectLink_Reason.ChildObjectId,0)
     LIMIT 1;


    
     --
     vbSubjectDocCode := lfGet_ObjectCode (vbSubjectDocCode, zc_Object_SubjectDoc());

     vbSubjectDocId := gpInsertUpdate_Object_SubjectDoc(ioId           := COALESCE (vbSubjectDocId,0) ::Integer 
                                            , inCode         := CASE WHEN vbSubjectDocCode < 1001 THEN 1001 ELSE vbSubjectDocCode END ::Integer
                                            , inName         := TRIM (inSubjectDocName)     :: TVarChar
                                            , inShort        := TRIM (inShort)              :: TVarChar
                                            , inReasonId     := vbReasonId                  :: Integer
                                            , inMovementDesc := NULL                        :: TVarChar   
                                            , inComment      := TRIM (inMovementDesc)       :: TVarChar  
                                            , inSession      := inSession                   :: TVarChar
                                            );
   
    --���� �������� �� ��������
     UPDATE Object
     SET isErased = TRUE
     WHERE Object.Id = vbSubjectDocId
       AND DescId = zc_Object_SubjectDoc();
     
     UPDATE Object
     SET isErased = TRUE
     WHERE Object.Id = vbReasonId
       AND DescId = zc_Object_Reason();  
       
   /*
   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION '����. ��. <%>', inSubjectDocName; 
   END IF;   
   */

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
/*
SELECT * FROM gpInsertUpdate_Object_SubjectDoc_Load(
     inSubjectDocName := '���������� ��� - ����������':: TVarChar   ,
     inShort          := '��-����������� �������'::TVarChar  , -- 
     inReasonName     := '���. ����� (������)' ::TVarChar  ,
     inMovementDesc   := '������� �� ���������� / ����������� �� ����' ::TVarChar ,
     inSession        := '9457'::TVarChar 
     )
*/