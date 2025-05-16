import os
import os.path
import sys

sys.path.append('/models/resources/viya/b1a026c6-6d4a-480d-b951-1311627f4f56/')

import HMEQ_XGBOOSTScore

import settings_b1a026c6_6d4a_480d_b951_1311627f4f56

settings_b1a026c6_6d4a_480d_b951_1311627f4f56.pickle_path = '/models/resources/viya/b1a026c6-6d4a-480d-b951-1311627f4f56/'

def score_record(LOAN,MORTDUE,VALUE,REASON,JOB,YOJ,DEROG,DELINQ,CLAGE,NINQ,CLNO,DEBTINC):
    "Output: EM_EVENTPROBABILITY,EM_CLASSIFICATION"
    return HMEQ_XGBOOSTScore.scoreHMEQ_XGBOOST(LOAN,MORTDUE,VALUE,REASON,JOB,YOJ,DEROG,DELINQ,CLAGE,NINQ,CLNO,DEBTINC)

print(score_record(76.27,2.3,50.49,"","",152.44,77.77,161.69,101.73,187.82,120.83,102.68))
