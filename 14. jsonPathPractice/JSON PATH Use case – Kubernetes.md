6. $.kind
7. $.metadata.name
8. $.spec.nodeName
9. $.spec.containers[0]
10. $.spec.containers[0].image
11. $.status.phase
12. $.status.containerStatuses[0].state.waiting.reason
13. $.status.containerStatuses[1].restartCount
14. $.status.containerStatuses[?(@.name == 'redis-container')].restartCount