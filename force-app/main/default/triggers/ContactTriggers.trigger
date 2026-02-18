trigger ContactTriggers on Contact (before insert) {
    System.debug('Hello world');
}