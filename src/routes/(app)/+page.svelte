<script>
    import Header from '$lib/Header.svelte';

    export let data;
    $: subs = data.subs;
</script>

<Header />
<div class="main">
    <div class="subs">
        <div style="height: 10px;"></div>
        {#each subs as sub (sub.id)}
            <div class="sub">
                <div class="note">
                    <p>{sub.id}</p>
                </div>
                <div class="sub-content">
                    <p class="title">{sub.title}</p>
                    <p class="content">{sub.body}</p>
                </div>
            </div>
        {/each}
        <div style="height: 10px;"></div>
    </div>
</div>

<style>
    .main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }
    .subs {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        margin-top: 2em;

        max-width: 95%;
        border: 3px solid #000;
        border-radius: 25px;
    }
    .note {
        background: red;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        font-size: 1.2em;
        margin-right: 1em;

        display: flex;
        justify-content: center;
        align-items: center;
    }
    .sub {
        display: flex;
        flex-direction: row;
        align-items: center;

        margin: 10px 0;
        padding-left: 1em;

        width: 97%;
        border: 3px solid #000;
        border-radius: 15px;
    }
    .title {
        font-size: 1.5em;
    }
</style>