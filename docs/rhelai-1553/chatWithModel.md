## Chat with the model

### Chat using the ilab command

``` shell
# ilab model chat --endpoint-url http://127.0.0.1:8000/v1 --model hello1
```

``` shell
╭─────────────────────────────────────────────────────────────────────────────────── system ────────────────────────────────────────────────────────────────────────────────────╮
│ Welcome to InstructLab Chat w/ HELLO1 (type /h for help)                                                                                                                      │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
>>> When did the Olympics began                                                                                                                                      [S][default]
╭─────────────────────────────────────────────────────────────────────────────────── hello1 ────────────────────────────────────────────────────────────────────────────────────╮
│ The Olympics have a rich history, dating back to ancient times. The first Olympic Games are believed to have taken place in 776 BC in Olympia, a sanctuary site in Greece.    │
│ These early games were part of the Panhellenic Games, a series of athletic festivals held in honor of the Greek god Zeus. The Olympics were initially an integral part of the │
│ religious cult, serving as a celebration of human strength, skill, and athletic prowess.                                                                                      │
│                                                                                                                                                                               │
│ The modern Olympics, as we know them today, were first held in 1896 in Athens, Greece. The founder of the modern Games was Pierre de Coubertin, a French educator and         │
│ historian. He aimed to promote peace, unity, and friendship among nations through the celebration of sports. The games were initially held every four years, but in 1932,     │
│ they were moved to an annual basis.                                                                                                                                           │
│                                                                                                                                                                               │
│ The Olympics have since evolved into a significant global event, featuring athletes from more than 200 countries. The games include a wide variety of sports and disciplines, │
│ from track and field and swimming to skiing and snowboarding. The Olympics have also become a platform for social change, with initiatives aimed at promoting gender          │
│ equality, environmental sustainability, and cultural exchange.                                                                                                                │
│                                                                                                                                                                               │
│ In conclusion, the Olympics have a history spanning over three millennia, and they continue to be a significant cultural and sporting event today. The games have evolved     │
│ over time, reflecting the changing values and priorities of society, but their core mission remains the same: to celebrate human achievement, promote peace, and unite people │
│ from all corners of the world.                                                                                                                                                │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── elapsed 4.443 seconds ─╯
>>>
```


### Chat using curl

``` shell
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "hello1",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "When did the Olympics began"}
    ]
  }'
```

```
{
  "id": "cmpl-d4f442c0126842338574e3d1f653edb5",
  "object": "chat.completion",
  "created": 1726779369,
  "model": "hello1",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "The history of the Olympics dates back to ancient Greece, with the first Olympic Games held in 776 BC in Olympia, a sanctuary site dedicated to Zeus, the king of the Greek gods. These early games were part of the Panhellenic Games, a series of athletic festivals held in honor of the goddess Hera.\n\nThe Olympic Games gained international recognition in 1896 when they were revived in Athens, Greece, as part of the Modern Olympic Games movement. The idea behind this revival was to promote peace and friendship among nations, as well as to celebrate athletic excellence. The games have since been held every four years, with the exception of the 2021 Games being postponed due to the COVID-19 pandemic.\n\nThe Olympics have evolved over time, incorporating various sports and events that reflect the changing values and interests of society. Today, the games include a wide range of disciplines, such as athletics, swimming, gymnastics, cycling, and winter sports, among others. The Olympics also serve as a platform for cultural exchange and understanding, bringing together athletes from around the world to compete and showcase their talents.\n\nIn summary, the Olympic Games have a rich history that spans over three millennia, and they continue to be a significant event in the global sports calendar, promoting peace, friendship, and athletic excellence.",
        "tool_calls": []
      },
      "logprobs": null,
      "finish_reason": "stop",
      "stop_reason": null
    }
  ],
  "usage": {
    "prompt_tokens": 22,
    "total_tokens": 331,
    "completion_tokens": 309
  }
}
```

