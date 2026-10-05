# R4 Sibling Merge: Method Evidence 갱신

이번 세션에서 **R4 sibling merge**가 1건 이상 실행된 경우 (≥2 meetings → 1 노트 merge), `sibling-meeting-merge-n-to-one-consolidation-method` 노트의 evidence 테이블을 자동 갱신한다.

**절차**:
1. 이번 /vault-sync 라운드에서 수행한 R4 merge 노트 목록 수집 (target note + merged sessions count)
2. `mcp__obsidian__read_note('notes/sibling-meeting-merge-n-to-one-consolidation-method.md')` 호출
3. `## 실증 사례 (3건, YYYY-MM-DD 기준)` 테이블에서 해당 merged 노트 행 찾기
4. **누적 N 증가**: `N = 기존 N + 이번 라운드 병합 수`
5. **날짜 분포 append**: `기존 분포 + MM-DD(N추가)` 형태로 append
6. `mcp__obsidian__patch_note`로 테이블 갱신
7. 신규 merged 노트(케이스 추가)인 경우 **새 행** 추가
