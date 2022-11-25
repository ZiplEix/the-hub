<script>
    import Button from '$lib/Header-button.svelte';
</script>

<div class="main">
    <div class="right">
        <div class="logo">
            <a href="/"><h1>THE HUB</h1></a>
        </div>
    </div>
    <div class="left">
        <div class="addSub">
            <Button class="addSub" type="secondary">+ SUB</Button>
        </div>
        <Button>ACOUNT</Button>
    </div>
</div>

<style>
    .main {
        display: flex;
        flex-direction: row;
        align-items: center;

        background: rgb(255, 255, 255);
        min-height: 50px;
        padding: 0 1em;
        max-height: 70px;
        box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.3);
        border-radius: 10px;
    }
    .right {
        flex: 1;
    }
    .left {
        flex: 1;
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
        padding: 0 1em;
    }
    .logo {
        margin-right: 1em;
    }
    .addSub {
        margin-right: 1em;
    }
</style>
