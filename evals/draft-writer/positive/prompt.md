Run the draft-writer skill in write-drafts mode for the request below.

importance threshold: medium
max drafts per run: 3

```json
{
  "schemaVersion": "maru_task_candidates_v1",
  "summary": "후보 2건",
  "candidates": [
    {
      "title": "2027년 교육사업 예산안 회신",
      "importance": "high",
      "confidence": 0.8,
      "originRefs": ["inbox/items/pending/261010-gws-budget-reply/summary.md"],
      "summary": "협력기관의 2027년 예산안 항목별 확정 여부와 장비비 이월 가능 여부 회신 필요(기한 10-17)",
      "draftBody": "예산안 3개 항목 확인 후 회신"
    },
    {
      "title": "점심 메뉴 투표 참여",
      "importance": "low",
      "confidence": 0.4,
      "originRefs": ["inbox/items/pending/261011-kakao-lunch-poll/summary.md"],
      "summary": "단체방 점심 메뉴 투표",
      "draftBody": "투표 참여"
    }
  ]
}
```
