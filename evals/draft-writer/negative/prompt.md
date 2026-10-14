Run the draft-writer skill in write-drafts mode for the request below.

importance threshold: medium
max drafts per run: 3

```json
{
  "schemaVersion": "maru_task_candidates_v1",
  "summary": "후보 1건",
  "candidates": [
    {
      "title": "실습 장비 견적 회신",
      "importance": "high",
      "confidence": 0.7,
      "originRefs": ["inbox/items/pending/261012-gws-vendor-quote/summary.md"],
      "summary": "노트북 20대 견적 확인 및 발주 여부 회신 필요(유효기간 10-31)",
      "draftBody": "견적 금액 확인 후 회신"
    }
  ]
}
```
