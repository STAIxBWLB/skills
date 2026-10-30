# R4 Sibling Merge: Method Evidence 갱신

이번 세션에서 **R4 sibling merge**가 1건 이상 실행된 경우 (≥2 meetings → 1 노트 merge), `sibling-meeting-merge-n-to-one-consolidation-method` 노트의 evidence 테이블을 자동 갱신한다.

**절차**:
1. 이번 /vault-sync 라운드에서 수행한 R4 merge 노트 목록 수집 (target note + merged sessions count)
2. `vmem_read(path: 'sibling-meeting-merge-n-to-one-consolidation-method')` 호출 (sha256 보관)
3. `## 실증 사례 (3건, YYYY-MM-DD 기준)` 테이블에서 해당 merged 노트 행 찾기
4. **누적 N 증가**: `N = 기존 N + 이번 라운드 병합 수`
5. **날짜 분포 append**: `기존 분포 + MM-DD(N추가)` 형태로 append
6. 표 전체를 한 번의 `vmem_patch(path, oldString: <기존 표 전체>, newString: <갱신 표 전체>, expectedSha: <2단계 sha256>)`로 갱신 (행 추가 포함). 나눠 고쳐야 하면 매 patch 뒤 `vmem_read`로 새 sha256을 받아 다음 patch에 쓴다. expect: vmem refuses a stale `expectedSha` (V09)
7. 신규 merged 노트(케이스 추가)인 경우 **새 행** 추가
